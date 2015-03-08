# rails runner tools/get_access_token.rb
require "oauth"
consumer = OAuth::Consumer.new(Global.app.consumer_key,
                               Global.app.consumer_secret,
                               site: "http://www.tumblr.com")
request_token = consumer.get_request_token(exclude_callback: true)
`open #{request_token.authorize_url}`
