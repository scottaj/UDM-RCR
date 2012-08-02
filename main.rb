require 'bundler/setup'
require 'sinatra'
require 'slim'
require 'mongoid'
require 'yaml'
require 'uri'
require 'coffee-script'

require_relative 'lib/rcr'
require_relative 'lib/room_info'

class RCRApp < Sinatra::Base
  configure do
    enable :sessions

    
    Mongoid.configure do |config|
      if ENV['MONGOLAB_URI']
        uri = URI.parse(ENV['MONGOLAB_URI'])
        conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
        db = conn.db(uri.path.gsub(/^\//, ''))
        config.master = db
      elsif ENV['RACK_ENV'] == 'test'
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

    def get_items_for_category_in_rcr(category, rcr)
      items = @@room_info.get_items_for_room(rcr.building, rcr.room_number).keep_if {|item| item[:category] == category}
      rated_items = rcr.room_items.where(category: category)
      rated_items.each do |item|
      found = items.index {|i| item.name == i[:name]}
        if found
          items[found][:rating] = item.rating
          items[found][:comments] = item.comments
        end
      end
      return items
    end

    def get_current_rcr()
      RCR.get_rcr_for_term_by_token(session[:token], session[:active_term][:year], session[:active_term][:term])
    end

    def save_ratings(ratings, category, rcr)
    
      ratings.each_value do |rating|
        if rating[1].to_i > 0        
        rcr.update_or_create_room_item({category: category,
                                         name: rating[0],
                                         rating: rating[1].to_i,
                                         comments: rating[2]})
        end
      end
    end

    def get_item_names_for_current_rcr()
      rcr = get_current_rcr
      return @@room_info.get_items_for_room(rcr.building, rcr.room_number).map {|item| item[:name]}
    end

    def get_rated_item_names()
      rcr = get_current_rcr
      return rcr.get_rated_items()
    end
  end

  
#### ROUTING ####

  
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
    rcr = get_current_rcr()
    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"
    term = "#{session[:active_term][:term]} #{session[:active_term][:year]}"
    slim :confirm, locals: {page_title: "Confirmation", name: name, room: room, term: term}
  end
  
  get '/RCR' do
    rcr = get_current_rcr()
    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"
    begin
      categories = @@room_info.get_categories_for_area(@@room_info.get_area_for_room(rcr.building, rcr.room_number))
    rescue RuntimeError
      redirect '/notfound'
    end
    if params[:category]
      if params[:category] == categories[0]
        page_type = "first"
      elsif params[:category] == categories[-1]
        page_type = "last"
      else
        page_type = "middle"
      end
      items = get_items_for_category_in_rcr(params[:category], rcr)
      slim :rcr, locals: {page_title: "RCR Submission", name: name, room: room, categories: categories, current_category: params[:category], items: items, page_type: page_type}
    else
      redirect "/RCR?category=#{categories[0]}"
    end
  end

  post '/previouscategory' do
    rcr = get_current_rcr()
    save_ratings(params[:ratings], params[:category], rcr)
    categories = @@room_info.get_categories_for_area(@@room_info.get_area_for_room(rcr.building, rcr.room_number))
    new_category = categories[categories.index(params[:category]) - 1]
    return new_category
  end

  post '/nextcategory' do
    rcr = get_current_rcr()
    save_ratings(params[:ratings], params[:category], rcr)
    categories = @@room_info.get_categories_for_area(@@room_info.get_area_for_room(rcr.building, rcr.room_number))
    new_category = categories[categories.index(params[:category]) + 1]
    return new_category
  end

  post '/submit' do
    rcr = get_current_rcr()
    save_ratings(params[:ratings], params[:category], rcr)
    all_items = get_item_names_for_current_rcr()
    rated_items = get_rated_item_names()
    if (all_items - rated_items).empty?
      rcr.mark_complete
      session[:submitted] = true
      return "complete"
    else
      return "incomplete"
    end
  end

  get '/submit' do
    if session[:submitted]
      slim :rcr_complete, locals: {page_title: "RCR Complete"}
    else
      error(404)
    end
  end

  get '/notfound' do
    slim :not_found, locals: {page_title: "Error"}
  end
end

if __FILE__ == $0
  port = `echo $PORT`.to_i
  RCRApp.run! :port => port > 0 ? port : 4567
end
