require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'
require 'yaml'

require_relative 'lib/rcr'
require_relative 'lib/room_info'

class RCRApp < Sinatra::Base
  configure do
    enable :sessions

    Mongoid.configure do |config|
      name = "rcr_app"
      host = "localhost"
      config.master = Mongo::Connection.new.db(name)
    end

    Slim::Engine.set_default_options :pretty => true
  end

  helpers do
    def generate_token(n)
      return rand(36**n).to_s(36)
    end
  end

  before /\/admin.*/ do
    
  end

  before '/submit' do
    
  end

  get '/' do
    # Load active term data
    File.open('active.yml', 'r') {|f| session[:active_term] = YAML::load(f)}
    slim :index, locals: {page_title: "Sign In", message: nil}
  end

  post '/' do
    if RCR.token_exists_for_term?(params[:token], session[:active_term][:year], session[:active_term][:term])
      session[:token] = params[:token]
      redirect '/submit'
    else
      slim :index, locals: {page_title: "Sign In", message: "Token not found!"}
    end
  end

  get '/submit' do
    
  end
  
  post '/submit' do
  
  end

  get '/admin' do
  
  end
end


RCRApp.run! if __FILE__ == $0
