require "sinatra/base"
require "slim"

class App < Sinatra::Base

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    Slim::Engine.default_options[:pretty] = true
  end

  get "/" do
    @image_files = Dir.glob("archive/*")
    slim :index
  end
end
