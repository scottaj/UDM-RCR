RcrApp.controllers :login do

  get :index do
    render :index, locals: {page_title: "Sign In", message: nil}
  end

  post :index do
    rcr = find_rcr_with_token(params[:token])
    unless rcr.nil? or rcr.complete?
      session[:token] = params[:token]
      redirect '/login/confirm'
    else
      message = rcr.nil? ? "Token not found!" : "RCR Already Completed!"
      render :index, locals: {page_title: "Sign In", message: message}
    end
  end

  get :confirm do
    rcr = session_rcr()
    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"
    term = "#{rcr.term.name}"
    render :confirm, locals: {page_title: "Confirmation", name: name, room: room, term: term}
  end
end
