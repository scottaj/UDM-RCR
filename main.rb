require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'

class RCRApp < Sinatra::Base
  configure do
    set :environment, :development
    # Mongoid.load!("./mongoid.yml")
    Mongoid.configure do |config|
      name = "rcr_app"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end
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
