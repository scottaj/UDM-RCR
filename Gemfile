source :rubygems

# Server requirements
gem 'thin'
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Development tools
group :development do
  gem "heroku"
  gem "rdoc"
  gem "ruby_parser"
  gem "pry"
end

# Component requirements
gem 'slim'
gem 'mongoid'
gem 'bson_ext', :require => "mongo"
gem "coffee-script"
gem "therubyracer"

# Test requirements
group :test do
  gem "rspec"
  gem "capybara"
  gem "capybara-webkit", :git => "git://github.com/thoughtbot/capybara-webkit.git", :branch => "master"
  gem "cucumber"
  gem "cucumber-sinatra"
  gem "database_cleaner"
  gem "prickle"
end

# Padrino Stable Gem
gem 'padrino', '0.10.7'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'
