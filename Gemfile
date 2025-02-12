source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "8.0.1"

gem "activerecord-simple_index_name"
gem "bootsnap", require: false
gem "carrierwave"
gem "fastimage", require: false
gem "global"
gem "importmap-rails"
gem "jbuilder"
gem "kaminari"
gem "mysql2"
gem "omniauth"
gem "omniauth-tumblr"
gem "puma"
gem "rmagick"
gem "sidekiq"
gem "sidekiq-cron"
gem "slim-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tumblr_client", require: false, github: "tumblr/tumblr_client", ref: "v0.8.6"
gem "turbo-rails"

group :development, :test do
  gem "debug", require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

