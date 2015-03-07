$LOAD_PATH.push File.expand_path(__dir__)
require "bundler/setup"
Bundler.require

map "/archive" do
  run Rack::Directory.new("./archive")
end

require "app"
run App
