# Helper methods defined here can be accessed in any controller or view in the application

RcrApp.helpers do
  def find_rcr_with_token(token)
    return Term.current_term.rcrs.find_by(token: token)
  end

  def session_rcr()
    find_rcr_with_token(session[:token])
  end
end
