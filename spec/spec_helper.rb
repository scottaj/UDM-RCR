ENV["RACK_ENV"] = 'test'	
PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)

require 'rack/test'

require_relative '../main'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods	
end
