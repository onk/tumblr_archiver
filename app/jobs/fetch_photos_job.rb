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
    @urls = []

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
          @urls << original["url"]

          photo = post.photos.find_or_create_by(user_id: @user.id, url: original["url"]) do |p|
            p.original_post_id = post_json["id"]
            p.width            = original["width"]
            p.height           = original["height"]
          end
        end
      end
      offset += per_page
      sleep 1
    end
  end

  def download
    FileUtils.mkdir_p(Rails.root.join("archive"))

    total_url = @urls.count
    @urls.each do |url|
      filename = Rails.root.join("archive", File.basename(url))
      unless File.exist?(filename)
        begin
          File.binwrite(filename, Net::HTTP.get_response(URI.parse(url)).body)
        rescue => e
          Rails.logger.error(e)
        end
        sleep 1
      end
    end
  end
end
