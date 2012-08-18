require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'uri'

begin
  require 'rdoc/task'
  require 'rake/testtask'
  require 'cucumber'
  require 'cucumber/rake/task'

  RDoc::Task.new do |rdoc|
    files =['README.md', 'lib/**/*.rb', 'lib/**/*.rbw', 'main.rb']
    rdoc.external = true
    rdoc.rdoc_files.add(files)
    rdoc.main = "README" # page to start on
    rdoc.title = "RCR App Source Documentation"
    rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
    rdoc.options << '--line-numbers'
    rdoc.options << '--all'
    rdoc.options << '--promiscuous'
  end

  Rake::TestTask.new do |t|
    t.test_files = FileList['test/**/*.rb']
  end

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
    t.rcov = false
  end
    
  rule(/features:(.+)/) do |t|
    match = /features:(.+)/.match(t.name)
    name = match[1]
    Cucumber::Rake::Task.new(name) do |t|
      t.rcov = false
      t.cucumber_opts = ["--name #{name}"]	
    end	
    Rake::Task[name].invoke
  end
  
  task "default" => [:test, :spec, :features]
rescue LoadError
  puts "One of the testing libraries doesn't seemed to be installed."
end

begin
  require "rspec/core/rake_task"
 	
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w[--color -f d]
    t.pattern = 'spec/**/*_spec.rb'	
  end
rescue LoadError
  puts "Couldn't require \"rspec/core/rake_task\". Is rspec installed?"
  task :spec do |t|
    exit  	
  end	
end

desc "Seed the current database with dummy data"
task :db_seed do
  require "mongoid"
  require_relative "lib/rcr"
  require_relative "lib/area_mapping"
  Mongoid.configure do |config|
    if ENV['MONGOLAB_URI']
      uri = URI.parse(ENV['MONGOLAB_URI'])
      conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    else
      name = "rcr_app"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end
  end

  # Insert dummy config
  mcnichols = Area.create(name: "McNichols")
  mcnichols.items.create(category: "Furniture",
                         name: "Bed",
                         description: "The thing you sleep in.")
  mcnichols.items.create(category: "Structural",
                         name: "Ceiling",
                         description: "Check for missing tiles, water damage, chips, etc.")
  mcnichols.items.create(category: "Structural",
                         name: "Floor",
                         description: "Check for cracked tiles, scuff marks, stains, etc.")
  mcnichols.items.create(category: "Structural",
                         name: "Walls",
                         description: "Check for holes, stickers, writing, etc.")
  
  quads = Area.create(name: "Quads")
  quads.items.create(category: "Bathroom",
                     name: "Shower",
                     description: "Make sure shower works and has no missing tiles, etc.")

  eqd = AreaMapping.create(name: "East Quad Double",
                           building: "East Quad")
  eqd.map_rooms("101-112, 114, 116, 201-216")
  eqd.areas = [mcnichols, quads]
  
  # insert dummy RCR's
  RCR.create(token: "abc123",
             term_year: 2012,
             term_name: "Summer",
             first_name: "Jane",
             last_name: "Doe",
             email: "jdoe@example.com",
             building: "East Quad",
             room_number: 210,
             complete: false)
  
  RCR.create(token: "a1b2c3",
             term_year: 2012,
             term_name: "Summer",
             first_name: "Jack",
             last_name: "Johnson",
             email: "jj@example.com",
             building: "Holden",
             room_number: 311,
             complete: false)

  RCR.create(token: "abc123",
             term_year: 2013,
             term_name: "Fall",
             first_name: "Diamond",
             last_name: "Dallas",
             email: "dd@example.com",
             building: "East Quad",
             room_number: 210,
             complete: false)

  RCR.create(token: "321cba",
             term_year: 2013,
             term_name: "Fall",
             first_name: "Jane",
             last_name: "Doe",
             email: "jdoe@example.com",
             building: "East Quad",
             room_number: 204,
             complete: false)
end

desc "Clear out the current database"
task :db_clean do
  require_relative "lib/rcr"
  require "mongo"
  if ENV['MONGOLAB_URI']
    uri = URI.parse(ENV['MONGOLAB_URI'])
    conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
    db_conn = conn.db(uri.path.gsub(/^\//, ''))
  else
    name = "rcr_app"
    host = "localhost"
    db_conn = Mongo::Connection.new.db(name)
  end
  collections = ["rcrs", "areas", "area_mappings"]
  collections.each {|collection| db_conn.collection(collection).drop}
end

task :db_seed => :db_clean

desc "Run all tests"
task :default do
end

desc "Run continuous integration tests"
task :ci do
end

task :ci => :default
