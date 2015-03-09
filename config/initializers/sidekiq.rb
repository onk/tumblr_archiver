require "sidekiq/web"

module RedisConnectionSetting
  def self.to_url(config)
    config = config.with_indifferent_access
    "redis://#{config[:host]}:#{config[:port]}/#{config[:db]}"
  end
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: RedisConnectionSetting.to_url(Global.redis.queue.to_hash),
    namespace: Global.redis.queue.namespace,
  }
end

# When in Unicorn, this block needs to go in unicorn's `after_fork` callback:
Sidekiq.configure_client do |config|
  config.redis = {
    url: RedisConnectionSetting.to_url(Global.redis.queue.to_hash),
    namespace: Global.redis.queue.namespace,
  }
end
