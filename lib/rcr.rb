require 'mongoid'

class RCR
  include Mongoid::Document
  field :term_year, type: Integer
  field :term_name, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :building, type: String
  field :room_number, type: Integer
  field :complete, type: Boolean
  embeds_many :roomitems  
end
