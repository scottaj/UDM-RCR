begin
  require 'cucumber'
  require 'cucumber/rake/task'

  desc "Run high level application test suite"
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
  
rescue LoadError
  puts "Cucumber doesn't seemed to be installed."
end
