require "sinatra/base"
require "slim"
require "yaml"
require "active_record"

def initialize_database
  path = File.join(__dir__, "config/database.yml")
  spec = YAML.load_file(path) || {}
  ActiveRecord::Base.configurations = spec.stringify_keys
  ActiveRecord::Base.establish_connection(:development)
end

def require_models
  Dir.glob("models/**/*.rb").each do |f|
    require f
  end
end

class App < Sinatra::Base
  initialize_database
  require_models

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    Slim::Engine.options[:pretty] = true
  end

  get "/" do
    @image_files = Photo.all
    slim :index
  end
end
