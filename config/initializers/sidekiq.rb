require "sidekiq/web"
require "sidekiq/cron/web"

yaml = Rails.application.root.join("config/redis.yml")
loaded_yaml = ActiveSupport::ConfigurationFile.parse(yaml)

Sidekiq.configure_server do |config|
  config.redis = loaded_yaml[Rails.env]["queue"]
  schedule_file = Rails.root.join("config/schedule.yml")
  Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = loaded_yaml[Rails.env]["queue"]
end
