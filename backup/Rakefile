require "bundler/setup"
Bundler.require
load "active_record/railties/databases.rake"

# http://qiita.com/kamipo/items/6e5a1e238d7cc0611ade
module ActiveRecord::ConnectionAdapters::SchemaStatements
  def index_name(table_name, options)
    if Hash === options
      if options[:column]
        "#{Array(options[:column]) * '_and_'}"
      elsif options[:name]
        options[:name]
      else
        raise ArgumentError, "You must specify the index name"
      end
    else
      index_name(table_name, :column => options)
    end
  end
end

seed_loader = Object.new
seed_loader.instance_eval do
  def load_seed
    load "#{ActiveRecord::Tasks::DatabaseTasks.db_dir}/seeds.rb"
  end
end

# overwrite rails config
ActiveRecord::Tasks::DatabaseTasks.tap do |config|
  config.migrations_paths       = ["db/migrate"]
  config.env                    = "development"
  config.database_configuration = ActiveRecord::Base.configurations
  config.db_dir                 = "db"
  config.root                   = Rake.application.original_dir
  config.seed_loader            = seed_loader
end

namespace :db do
  task :load_config do
    path = File.join(ActiveRecord::Tasks::DatabaseTasks.root, "config/database.yml")
    spec = YAML.load_file(path) || {}
    ActiveRecord::Base.configurations = spec.stringify_keys
  end

  task :environment => :load_config do
    ActiveRecord::Base.establish_connection(ActiveRecord::Tasks::DatabaseTasks.env.to_sym)
  end
end

# copy from sinatra-activerecord
namespace :db do
  desc "Create a migration (parameters: NAME, VERSION)"
  task :create_migration do
    unless ENV["NAME"]
      puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_users`"
      exit
    end

    name    = ENV["NAME"]
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

    ActiveRecord::Migrator.migrations_paths.each do |directory|
      next unless File.exist?(directory)
      migration_files = Pathname(directory).children
      if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
        puts "Another migration is already named \"#{name}\": #{duplicate}."
        exit
      end
    end

    filename = "#{version}_#{name}.rb"
    dirname  = ActiveRecord::Migrator.migrations_path
    path     = File.join(dirname, filename)

    FileUtils.mkdir_p(dirname)
    File.write path, <<-MIGRATION.strip_heredoc
      class #{name.camelize} < ActiveRecord::Migration
        def change
        end
      end
    MIGRATION

    puts path
  end
end
