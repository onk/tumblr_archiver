Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.allowed_request_methods = %i[get post]
    config.silence_get_warning = true
  end
  provider :tumblr, Global.app.consumer_key, Global.app.consumer_secret
end
