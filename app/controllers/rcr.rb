RcrApp.controllers :rcr do

  get :index do
    rcr = session_rcr

    name = "#{rcr.first_name} #{rcr.last_name}"
    room = "#{rcr.building} #{rcr.room_number}"

    categories = AreaMapping.get_category_names_for_room(rcr.building, rcr.room_number).to_a.sort
    redirect "/rcr?category=#{categories[0]}" unless params[:category]

    page_type = case params[:category]
                when categories[0]
                  "first"
                when categories[-1]
                  "last"
                else
                  "middle"
                end
    items = get_items_for_page(rcr, params[:category])

    render 'rcr/rcr', locals: {
      page_title: "RCR Submission",
      name: name,
      room: room,
      categories: categories,
      current_category: params[:category],
      items: items,
      page_type: page_type}
  end

  post :category do
    rcr = session_rcr
    save_ratings(params[:ratings], params[:category], rcr)
    categories = AreaMapping.get_category_names_for_room(rcr.building, rcr.room_number).to_a.sort
    return categories[categories.index(params[:category]) + params[:direction].to_i]
  end

  get :submit do
    if session[:submitted]
      slim 'rcr/rcr_complete', locals: {page_title: "RCR Complete"}
    else
      error(404)
    end
  end

  post :submit do
    rcr = session_rcr
    save_ratings(params[:ratings], params[:category], rcr)
    items_left = AreaMapping.get_items_for_room(rcr.building, rcr.room_number).delete_if {|item|
      rcr.room_items.find_by(category: item.category, name: item.name)
    }

    if items_left.empty?
      rcr.complete = session[:submitted] = true
      rcr.save
      return "complete"
    else
      content_type('application/json')
      return JSON::dump(items_left.map {|item| item.name})
    end
  end
end
