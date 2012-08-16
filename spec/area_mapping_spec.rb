require 'spec_helper'

describe "AreaMapping" do
  describe "map_rooms" do
    before do
      @am = AreaMapping.new
    end
  
    it "should convert ranges of rooms from a string into an array" do
      room_str = "1-4,17,18,23-24"
      @am.map_rooms(room_str)
      @am.rooms.should =~ [1,2,3,4,17,18,23,24]
    end

    it "should ignore junk in the data string" do
      room_str = "moose,3-4hi,2, 9-yo-11        ,w-8"
      @am.map_rooms(room_str)
      @am.rooms.should =~ [2]
    end

    it "should not contain duplicates" do
      room_str = "1-5,2-6,3,4"
      @am.map_rooms(room_str)
      @am.rooms.should =~ [1,2,3,4,5,6]
    end
  end
end
