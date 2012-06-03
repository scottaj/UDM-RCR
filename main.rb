require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'

class RCRApp < Sinatra::Base
  configure do
    Mongoid.load!("./mongoid.yml")
  end
end


RCRApp.run if __FILE__ == $0
