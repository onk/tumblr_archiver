require "fastimage"
require "tumblr_client"

class FetchPhotosJob
  include Sidekiq::Worker

  def perform
    User.all.each do |user|
      @user = user
      auth
      fetch_urls
      download
    end
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
    while offset < total_posts
      json = @client.posts("#{@user.name}.tumblr.com", type: :photo, offset: offset)
      total_posts = json["total_posts"]
      json["posts"].each do |post_json|
        next unless post_json["photos"]

        post = Post.find_or_create_by!(user_id: @user.id, original_id: post_json["id"]) do |p|
          p.url         = post_json["post_url"]
          p.posted_at   = Time.at(post_json["timestamp"])
          p.photo_count = post_json["photos"].count
        end

        post_json["photos"].each do |photo|
          original = photo["original_size"] || photo["alt_sizes"].max_by { |j| j["width"] }

          photo = post.photos.find_or_initialize_by(user_id: @user.id, url: original["url"]) do |p|
            p.original_post_id = post_json["id"]
          end
          photo[:image] = File.basename(original["url"])
          photo.save!
          @photos << photo
        end
      end
      offset += per_page
      sleep 1
    end
  end

  def download
    @photos.each do |photo|
      next if photo.has_downloaded?
      begin
        FileUtils.mkdir_p(File.dirname(photo.image.path))
        File.binwrite(photo.image.path, open(photo.url) { |f| f.read })
        photo.has_downloaded = true
        photo.average_hash   = AverageHash.calc_hash(Magick::Image.read(photo.image.path)[0])
        width, height = FastImage.size(photo.image.path)
        photo.width   = width
        photo.height  = height
        photo.save!
      rescue OpenURI::HTTPError => e
        Rails.logger.error(e)
      rescue Timeout::Error => e
        Rails.logger.error(e)
      rescue => e
        # その他のエラーも処理は継続
        Rails.logger.error(e)
      end
      sleep 1
    end
  end
end
