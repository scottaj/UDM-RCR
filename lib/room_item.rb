require 'mongoid'

class RoomItem
  include Mongoid::Document
  field :category, type: String
  field :item, type: String
  field :condition, type: Integer
  field :condition_notes, type: String
  embedded_in :rcr
end
