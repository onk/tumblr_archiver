#!/usr/bin/env ruby
require "bundler/setup"
require "open-uri"
Bundler.require
def auth
  Tumblr.configure do |config|
    config.consumer_key = "CzARxuVpLCbPy3oC07I022FK1UEfhUMmkjg7lYmMFat3Hbv6JQ"
    config.consumer_secret = "9cl2Ko3Mvwk5SM2zApx9iqLypocS4dQ3DHYao1uzoy8ML4kYDT"
    config.oauth_token = ENV["OAUTH_TOKEN"]
    config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
  end
  @client = Tumblr::Client.new
end

def fetch_urls
  urls = []

  per_page = 20
  offset = 0
  total_posts = 20 # 初期値
  while(offset < total_posts) do
    json = @client.posts("mayumayu.tumblr.com", type: :photo, offset: offset)
    total_posts = json["total_posts"]
    json["posts"].each do |post|
      next unless post["photos"]
      post["photos"].each do |photo|
        original = photo["original_size"] || photo["alt_sizes"].max_by{|j| j["width"]}
        urls << original["url"]
      end
    end
    offset += per_page
    p "#{offset}/#{total_posts}"
    sleep 1
  end
  urls
end

def download(urls)
  total_url = urls.count
  FileUtils.mkdir_p("archive")
  urls.each_with_index do |url, i|
    filename = File.join("archive", File.basename(url))
    unless File.exist?(filename)
      begin
        File.binwrite(filename, open(url) { |f| f.read })
      rescue OpenURI::HTTPError => e
        p e
      end
      sleep 1
    end
    p "#{i + 1}/#{total_url}"
  end
end

def main
  auth
  urls = fetch_urls
  download(urls)
end

main
