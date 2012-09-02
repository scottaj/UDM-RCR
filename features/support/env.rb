# Generated by cucumber-sinatra. (2012-06-13 21:46:34 -0400)

PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.join(File.dirname(__FILE__) , "..", "..", "config/boot")

require 'capybara'
require 'capybara/cucumber'
require 'capybara-webkit'
require 'test/unit/assertions'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'prickle/capybara'    # require

Capybara.app = RcrApp
Capybara.javascript_driver = :webkit
DatabaseCleaner.strategy = :truncation

class RCRAppWorld
  include Capybara::DSL
  include Test::Unit::Assertions
  include RSpec::Expectations
  include RSpec::Matchers
  include Prickle::Capybara  # include  Prickle
end

World do
  RCRAppWorld.new
end

Before do
  DatabaseCleaner.start

  Term.create(name: "Fall Down", start_date: Date.today - 10, end_date: Date.today + 20)
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
end

After do
  DatabaseCleaner.clean
end
