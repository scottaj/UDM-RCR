require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'

class RCRApp < Sinatra::Base
  configure do
    set :environment, :development
    Mongoid.load!("./mongoid.yml")
  end

  get '/' do
    
  end

  get '/submit' do
    
  end
  
  post '/submit' do
  
  end

  get '/admin' do
  
  end
end


RCRApp.run if __FILE__ == $0
