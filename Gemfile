source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "5.1.7"

gem "activerecord-simple_index_name"
gem "carrierwave"
gem "coffee-rails"
gem "fastimage", require: false
gem "global"
gem "jbuilder"
gem "jquery-rails"
gem "kaminari"
gem "mysql2"
gem "omniauth"
gem "omniauth-tumblr"
gem "puma"
gem "rmagick"
gem "sass-rails"
gem "sidekiq"
gem "sidekiq-cron"
gem "sinatra", require: false
gem "slim-rails"
gem "tumblr_client", require: false
gem "turbolinks"
gem "uglifier"

group :development, :test do
  gem "byebug"
end

group :development do
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

