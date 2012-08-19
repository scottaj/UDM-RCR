require 'set'

class MappingError < StandardError
end

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
  has_and_belongs_to_many :mappings, inverse_of: :areas, class_name: "AreaMapping"
end

##
# Maps rooms to areas
class AreaMapping
  include Mongoid::Document
  field :name, type: String
  field :building, type: String
  field :rooms, type: Set
  has_and_belongs_to_many :areas, inverse_of: :mappings, class_name: "Area"

  attr_accessor :conflicts

  def check_for_duplicates()
    duplicate = AreaMapping.where(building: self.building).in(rooms: self.rooms)
    
    unless duplicate.empty?
      @conflicts = {}
      duplicate.each do |mapping|
        @conflicts[mapping.name] = self.rooms & mapping.rooms
      end
      raise MappingError, "This mapping conflicts with an existing mapping"
    end
  end

  def save_areas()
    self.areas.each {|area| area.save}
  end
  
  before_save do
    check_for_duplicates
    save_areas
  end

  def self.get_area_names_for_room(building, room)
    mapping = self.where(building: building, rooms: room).first
    return Set[] unless mapping
    return Set.new(mapping.areas.map {|area| area.name})
  end
  
  def self.get_items_for_room(building, room_number)
    mapping = AreaMapping.where(building: building, rooms: room_number).first
    return Set[] unless mapping
    return Set.new(mapping.areas.map {|a| Set.new(a.items)}).flatten
  end

  def self.get_category_names_for_room(building, room_number)
    return self.get_items_for_room(building, room_number).map! {|item| item.category}
  end

  def map_rooms(room_number_string)
    rooms = Set[]
    room_number_string.split(/\s*,\s*/).each do |section|
      if section.match(/^[0-9]+-[0-9]+$/)
        section = section.split('-')
        rooms |= (section[0].to_i..section[1].to_i)
      else
        rooms << section.to_i if section.match(/^[0-9]+$/)
      end
    end
    self.rooms = rooms
  end
end
