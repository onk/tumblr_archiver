Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.allowed_request_methods = %i[get post]
    config.silence_get_warning = true
  end
  provider :tumblr, Rails.application.credentials.consumer_key, Rails.application.credentials.consumer_secret
end
