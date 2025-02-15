require "sidekiq/web"
require "sidekiq/cron/web"

Sidekiq.configure_server do |config|
  config.redis = Global.redis.queue.to_hash
  schedule_file = Rails.root.join("config/schedule.yml")
  Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = Global.redis.queue.to_hash
end
