require 'spec_helper'

describe "AreaMapping" do
  describe "Mapping rooms to areas" do

    after do
      AreaMapping.destroy_all
      Area.destroy_all
    end

    it "should save any areas in the mapping when the mapping is saved" do
      am = AreaMapping.new(name: "test", building: "test", rooms: Set[1,2,3,4,5])
      a = Area.new(name: "area1")
      am.areas << a
      
      a.persisted?.should be_false
      am.save
      a.persisted?.should be_true      
    end
    
    describe "Finding area names for a mapping" do

      it "should return a set of the area names that a room is in" do
        am = AreaMapping.new(name: "test", building: "test", rooms: Set[1,2,3,4,5])
        am.areas = [Area.new(name: "area1"), Area.new(name: "area2"), Area.new(name: "area3")]
        am.save
        AreaMapping.get_area_names_for_room("test", 3).should == Set["area1",
                                                                     "area2",
                                                                     "area3"]
      end

      it "should return an empty set if it can't find a mapping for a room" do
        AreaMapping.get_area_names_for_room("foo", 8).should == Set[]
      end
    end

    describe "Creating mappings" do
      
      it "should not allow you to save multiple mappings for a single room" do     
        lambda {
          AreaMapping.create(name: "test1", building: "test", rooms: Set[1,2,3])
        }.should_not raise_error
        lambda {
          AreaMapping.create(name: "test2", building: "test", rooms: Set[3,4,5])
        }.should raise_error(MappingError)
      end

      it "Should set the conflicts hash if there is a conflict while saving" do
        am1 = AreaMapping.create(name: "test", building: "test", rooms: Set[1,2,3])
        am2 = AreaMapping.create(name: "test2", building: "test", rooms: Set[6,7,8])
        am3 = AreaMapping.new(name: "test3", building: "test", rooms: Set[3,4,5,6])
        lambda {am3.save}.should raise_error
        am3.conflicts.should == {"test" => Set[3], "test2" => Set[6]}
     
      end
    end

    describe "Getting item data for a given room" do

      before do
        @area1 = Area.new(name: "test area 1")
        @area1.items = [Item.new(category: "Structural", name: "Floor"),
                       Item.new(category: "Structural", name: "Ceiling"),
                       Item.new(category: "Furniture", name: "Bed")]
        @area2 = Area.new(name: "test area 2")
        @area2.items = [Item.new(category: "Furniture", name: "Chair"),
                       Item.new(category: "Bathroom", name: "Toilet")]
        @am = AreaMapping.create(name: "test mapping",
                                building: "test",
                                rooms: Set[1,2,3,4,5],
                                areas: [@area1, @area2])

      end
      
      it "should return a set of all the items in a given room." do        
        AreaMapping.get_items_for_room("test", 2).should == Set.new(@area1.items) | Set.new(@area2.items)
      end

      it "should return an empty set if no mapping can be found for a room" do
        AreaMapping.get_items_for_room("fahrenheit", 451).should == Set[]
      end

      describe "Getting category information for items in a given room" do
        it "should return a set with the names of every category of items in the room" do
          AreaMapping.get_category_names_for_room("test", 3).should == Set["Structural", "Furniture", "Bathroom"]
        end

        it "should return an empty set if no mapping can be found for a room" do
          AreaMapping.get_category_names_for_room("fahrenheit", 451).should == Set[]
        end
      end
    end
    
    describe "Map string ranges to actual numbers" do
      before do
        @am = AreaMapping.new
      end
      
      it "should convert ranges of rooms from a string into an Set" do
        room_str = "1-4,17,18,23-24"
        @am.map_rooms(room_str)
        @am.rooms.should == Set[1,2,3,4,17,18,23,24]
      end

      it "should ignore junk in the data string" do
        room_str = "moose,3-4hi,2, 9-yo-11        ,w-8"
        @am.map_rooms(room_str)
        @am.rooms.should == Set[2]
      end
    end
  end
end
