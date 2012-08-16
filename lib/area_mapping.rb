require 'set'

class Item
  include Mongoid::Document
  field :category, type: String
  field :name, type: String
  field :description, type: String
  embedded_in :area
end

class Area
  include Mongoid::Document
  field :name, type: String
  embeds_many :items
  has_and_belongs_to_many :areamappings, class_name: "AreaMapping"
end

##
# Maps rooms to areas
class AreaMapping
  include Mongoid::Document
  field :name, type: String
  field :building, type: String
  field :rooms, type: Array
  has_and_belongs_to_many :areas
  
  def self.get_items_for_room(building, room_number)
    items = []
    mapping = AreaMapping.find_by(building: building, rooms: room_number)
    mapping.areas.each do |area|
      items += area.items
    end
    return items
  end

  def map_rooms(room_number_string)
    rooms = Set.new
    room_number_string.split(/\s*,\s*/).each do |section|
      if section.match(/^[0-9]+-[0-9]+$/)
        section = section.split('-')
        rooms |= (section[0].to_i..section[1].to_i)
      else
        rooms << section.to_i if section.match(/^[0-9]+$/)
      end
    end
    self.rooms = rooms.to_a
    self.save
  end
end
