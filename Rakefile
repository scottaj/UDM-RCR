require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'

task :default do
end

RDoc::Task.new do |rdoc|
  files =['README.md', 'lib/**/*.rb', 'lib/**/*.rbw', 'main.rb']
  rdoc.external = true
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "Twitter Clone Source Documentation"
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
end

task :db_seed do
  require_relative "lib/rcr"
  require "mongo"
  db_conn = Mongo::Connection.new.db("rcr_app").collection("rcrs")

  # insert dummy data
  db_conn.insert(token: "abc123",
                 term_year: 2012,
                 term_name: "Summer",
                 first_name: "Jane",
                 last_name: "Doe",
                 email: "jdoe@example.com",
                 building: "East Quad",
                 room_number: 210,
                 complete: false)
  
  db_conn.insert(token: "a1b2c3",
                 term_year: 2012,
                 term_name: "Summer",
                 first_name: "Jack",
                 last_name: "Johnson",
                 email: "jj@example.com",
                 building: "Holden",
                 room_number: 311,
                 complete: false)

  db_conn.insert(token: "abc123",
                 term_year: 2013,
                 term_name: "Fall",
                 first_name: "Diamond",
                 last_name: "Dallas",
                 email: "dd@example.com",
                 building: "East Quad",
                 room_number: 210,
                 complete: false)

  db_conn.insert(token: "321cba",
                 term_year: 2013,
                 term_name: "Fall",
                 first_name: "Jane",
                 last_name: "Doe",
                 email: "jdoe@example.com",
                 building: "East Quad",
                 room_number: 204,
                 complete: false)
end


task :db_clean do
  require_relative "lib/rcr"
  require "mongo"
  db_conn = Mongo::Connection.new.db("rcr_app").collection("rcrs")
  db_conn.drop
end

task "db_seed" => :db_clean
task "default" => :features
task "default" => :test
