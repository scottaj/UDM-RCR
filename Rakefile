require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'uri'

import 'spec/spec.rake'
import "features/cucumber.rake"

desc "Seed the current database with dummy data"
task :db_seed do
  ENV['MONGOID_ENV'] = ENV['db_env'] || 'development'

  require_relative 'config/database'
  Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }

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
  ENV['MONGOID_ENV'] = ENV['db_env'] || 'development'

  require_relative 'config/database'
  Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
  
  Area.destroy_all
  AreaMapping.destroy_all
  RCR.destroy_all
end

task :db_seed => :db_clean


task :default do
end

begin
  desc "Run continuous integration tests"
  task :ci do
  end
  
  task :ci => [:spec, :features]
rescue LoadError
  puts "Can\'t run test suites, are you in a production environment?"
end
