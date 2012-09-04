class RcrApp < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions
  set :logging, true
  set :reload, true
  layout :layout

  Slim::Engine.set_default_options :pretty => true
  Mongoid.raise_not_found_error = false
  
  get :index do
    redirect '/login'
  end
end
