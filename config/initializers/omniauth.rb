Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tumblr, Global.app.consumer_key, Global.app.consumer_secret
end
