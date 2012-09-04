# Helper methods defined here can be accessed in any controller or view in the application

RcrApp.helpers do
  def session_rcr()
    find_rcr_with_token(session[:token])
  end

  def save_ratings(ratings, category, rcr)
    ratings.each_value do |rating|
      if rating[1].to_i != 0
          item = rcr.room_items.find_or_create_by(category: category, name: rating[0])
        item.rating = rating[1].to_i
        item.comments = rating[2]
      end
    end
    rcr.save
  end
end
