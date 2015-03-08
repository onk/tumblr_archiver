#!/usr/bin/env ruby
# bundle exec から叩きましょう
require "bundler/setup"
Bundler.require

CONSUMER_KEY    = "CzARxuVpLCbPy3oC07I022FK1UEfhUMmkjg7lYmMFat3Hbv6JQ"
CONSUMER_SECRET = "9cl2Ko3Mvwk5SM2zApx9iqLypocS4dQ3DHYao1uzoy8ML4kYDT"
consumer = OAuth::Consumer.new(CONSUMER_KEY,
                                CONSUMER_SECRET,
                                site: "http://www.tumblr.com")
request_token = consumer.get_request_token(exclude_callback: true)
`open #{request_token.authorize_url}`
