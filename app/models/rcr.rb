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
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :building, type: String
  field :room_number, type: Integer
  field :complete, type: Boolean
  embeds_many :room_items
  belongs_to :term, class_name: "Term"

  alias :complete? :complete
end
