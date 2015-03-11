require "rmagick"
require "tumblr_client"

class FetchPhotosJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    @user = user
    auth
    fetch_urls
    download
  end

  def auth
    Tumblr.configure do |config|
      config.consumer_key       = Global.app.consumer_key
      config.consumer_secret    = Global.app.consumer_secret
      config.oauth_token        = @user.oauth_token
      config.oauth_token_secret = @user.oauth_token_secret
    end
    @client = Tumblr::Client.new
  end

  def fetch_urls
    @photos = []

    per_page = 20
    offset = 0
    total_posts = 20 # 初期値
    while(offset < total_posts) do
      json = @client.posts("#{@user.name}.tumblr.com", type: :photo, offset: offset)
      total_posts = json["total_posts"]
      json["posts"].each do |post_json|
        next unless post_json["photos"]

        post = Post.find_or_create_by(user_id: @user.id, original_id: post_json["id"]) do |p|
          p.url         = post_json["post_url"]
          p.posted_at   = Time.at(post_json["timestamp"])
          p.photo_count = post_json["photos"].count
        end

        post_json["photos"].each do |photo|
          original = photo["original_size"] || photo["alt_sizes"].max_by{|j| j["width"]}

          photo = post.photos.find_or_initialize_by(user_id: @user.id, url: original["url"]) do |p|
            p.original_post_id = post_json["id"]
            p.width            = original["width"]
            p.height           = original["height"]
          end
          photo[:image] = File.basename(original["url"])
          photo.save
          @photos << photo
        end
      end
      offset += per_page
      sleep 1
    end
  end

  def calc_hash(filename)
    original = Magick::Image.read(filename)[0]
    # 16x16 にリサイズして二値化 (16bitなので半分の 2**15 を閾値に)
    img = original.resize(16, 16).threshold(32768)
    # 各ピクセルごとにビットを立てる。白黒なので red の値だけ見ればいい
    bits = img.get_pixels(0, 0, img.columns, img.rows).map { |p| p.red == 0 ? 1 : 0 }
    # bit -> 16進文字列 にして DB に詰める
    bits.join.to_i(2).to_s(16)
  rescue Magick::ImageMagickError
    Rails.logger.error(e)
  end

  def download
    @photos.each do |photo|
      unless photo.has_downloaded?
        begin
          FileUtils.mkdir_p(File.dirname(photo.image.path))
          File.binwrite(photo.image.path, open(photo.url) { |f| f.read })
          photo.has_downloaded = true
          photo.average_hash   = calc_hash(photo.image.path)
          photo.save!
        rescue OpenURI::HTTPError => e
          Rails.logger.error(e)
        end
        sleep 1
      end
    end
  end
end
