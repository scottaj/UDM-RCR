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

  def get_items_for_page(rcr, category)
    all_items = AreaMapping.get_items_for_room(rcr.building, rcr.room_number).keep_if {|item| item.category == category}
    
    return all_items.map do |item|
      map = {name: item.name, category: item.category}
      rated_item = rcr.room_items.find_by(category: item.category, name: item.name)
      if rated_item
        map[:rating] = rated_item.rating
        map[:comments] = rated_item.comments
      end
      map
    end
  end
end
