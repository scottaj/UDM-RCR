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
  Term.create(name: "Fall 2012", start_date: Date.today - 10, end_date: Date.today + 20)
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
  eqd.save
  
  # insert dummy RCR's
  RCR.create(token: "abc123",
             first_name: "Jane",
             last_name: "Doe",
             email: "jdoe@example.com",
             building: "East Quad",
             room_number: 210,
             complete: false,
             term: Term.active_term)
  
  RCR.create(token: "a1b2c3",
             first_name: "Jack",
             last_name: "Johnson",
             email: "jj@example.com",
             building: "Holden",
             room_number: 311,
             complete: false,
             term: Term.active_term)

  RCR.create(token: "abc123",
             first_name: "Diamond",
             last_name: "Dallas",
             email: "dd@example.com",
             building: "East Quad",
             room_number: 210,
             complete: false,
             term: Term.active_term)

  RCR.create(token: "321cba",
             term_name: "Fall",
             first_name: "Jane",
             last_name: "Doe",
             email: "jdoe@example.com",
             building: "East Quad",
             room_number: 204,
             complete: false,
             term: Term.active_term)
end

desc "Clear out the current database"
task :db_clean do
  ENV['MONGOID_ENV'] = ENV['db_env'] || 'development'

  require_relative 'config/database'
  Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
  
  Area.destroy_all
  AreaMapping.destroy_all
  RCR.destroy_all
  Term.destroy_all
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
