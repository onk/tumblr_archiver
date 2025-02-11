require "sidekiq/web"
require "sidekiq/cron/web"

module RedisConnectionSetting
  def self.to_url(config)
    config = config.with_indifferent_access
    "redis://#{config[:host]}:#{config[:port]}/#{config[:db]}"
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: RedisConnectionSetting.to_url(Global.redis.queue.to_hash),
  }

  schedule_file = Rails.root.join("config/schedule.yml")
  Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = {
    url: RedisConnectionSetting.to_url(Global.redis.queue.to_hash),
  }
end
