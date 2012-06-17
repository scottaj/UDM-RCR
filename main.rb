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
      if ENV['RACK_ENV'] == 'test'
        name = "rcr_app_testing"
        host = 'localhost'
        config.master = Mongo::Connection.new.db(name)
      else
        name = "rcr_app"
        host = "localhost"
        config.master = Mongo::Connection.new.db(name)
      end
    end

    Slim::Engine.set_default_options :pretty => true

    @@room_info = RoomInfo.new("site-config.yml")
  end

  helpers do
    def generate_token(n)
      return rand(36**n).to_s(36)
    end
  end

  before /\/admin.*/ do
    
  end

  get '/' do
    # Load active term data
    File.open('active.yml', 'r') {|f| session[:active_term] = YAML::load(f)}
    slim :index, locals: {page_title: "Sign In", message: nil}
  end

  post '/' do
    if RCR.token_exists_for_term?(params[:token], session[:active_term][:year], session[:active_term][:term])
      session[:token] = params[:token]
      redirect '/confirm'
    else
      slim :index, locals: {page_title: "Sign In", message: "Token not found!"}
    end
  end

  get '/confirm' do
    rcr = RCR.get_rcr_for_term_by_token(session[:token], session[:active_term][:year], session[:active_term][:term])
    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"
    term = "#{session[:active_term][:term]} #{session[:active_term][:year]}"
    slim :confirm, locals: {page_title: "Confirmation", name: name, room: room, term: term}
  end
  
  get '/RCR' do
    rcr = RCR.get_rcr_for_term_by_token(session[:token], session[:active_term][:year], session[:active_term][:term])
    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"
    categories = @@room_info.get_categories_for_area(@@room_info.get_area_for_room(rcr.building, rcr.room_number))
    slim :rcr, locals: {page_title: "RCR Submission", name: name, room: room, categories: categories}
  end
end


RCRApp.run! if __FILE__ == $0
