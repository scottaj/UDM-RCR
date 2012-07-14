require 'mongoid'


class RoomItem
  include Mongoid::Document
  field :category, type: String
  field :name, type: String
  field :rating, type: Integer
  field :comments, type: String
  embedded_in :rcr
end

class RCR
  include Mongoid::Document
  field :token, type: String
  field :term_year, type: Integer
  field :term_name, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :building, type: String
  field :room_number, type: Integer
  field :complete, type: Boolean
  embeds_many :room_items

  def RCR.token_exists_for_term?(token, term_year, term_name)
    return true if RCR.where(token: token, term_year: term_year, term_name: term_name).first
    return false
  end

  def RCR.get_rcr_for_term_by_token(token, term_year, term_name)
    return RCR.where(token: token, term_year: term_year, term_name: term_name).first
  end

  def update_or_create_room_item(room_item_params)
    found = self.room_items.where(name: room_item_params[:name]).first
    if found
      found.update_attributes(room_item_params)
      self.save
    else
      self.room_items.create(room_item_params)
    end
  end

  def get_rated_items()
    return self.room_items.map {|item| item.name if (1..5).include?(item.rating)}
  end

  def mark_complete()
    self.update_attribute(:complete, true)
    self.save
  end
end
