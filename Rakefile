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