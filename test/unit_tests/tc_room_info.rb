require_relative '../../lib/room_info'
require 'test/unit'
require 'fileutils'

class TestRoomInfo < Test::Unit::TestCase
  def setup()
    @file = "../../testconfig.yml"
    @room_info = RoomInfo.new(@file)
  end

  def teardown()
    FileUtils.rm([@file])
  end

  def test_new_area()
    @room_info.save!
    assert_equal([], @room_info.config[:areas], "Testing that the defualt area value is correct")
    @room_info.new_area("Dorms")
    @room_info.save!
    assert_equal([{:name=>"Dorms", :parent=>nil, :categories=>[]}], @room_info.config[:areas], "Testing adding an area")
    @room_info.new_area("Shiple", "Dorms")
    @room_info.save!
    assert_equal([{:name=>"Dorms", :parent=>nil, :categories=>[]}, {:name=>"Shiple", :parent=>"Dorms", :categories=>[]}], @room_info.config[:areas], "Testing adding a second area")
  end

  def test_new_category()
    @room_info.new_area("Dorms")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.save!
    assert_equal([{name: "Furniture", items: []}], @room_info.config[:areas][0][:categories], "Testing adding a category")
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception") {@room_info.new_category("Foo", "Bar")} 
  end

  def test_new_item()
    @room_info.new_area("Dorms")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.new_item("Dorms", "Furniture", "Bed", "The thing you sleep in.")
    @room_info.save!
    assert_equal([{name: "Bed", description: "The thing you sleep in."}], @room_info.config[:areas][0][:categories][0][:items], "Testing adding an item.")
    assert_raise(RuntimeError, "Testing that a non-existant category raises an exception") {@room_info.new_item("Dorms", "bar", "baz", "bizzle")}
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception") {@room_info.new_item("Foo", "bar", "baz", "bizzle")}
  end


  def test_get_areas()
    assert_equal([], @room_info.get_areas(), "Testing with no areas added")
    @room_info.new_area("Dorms")
    @room_info.new_area("Quads", "Dorms")
    @room_info.save!
    assert_equal(["Dorms", "Quads"], @room_info.get_areas(), "Testing with some areas added")
  end

  def test_get_categories_in_area()
    @room_info.new_area("Dorms")
    @room_info.save!
    assert_equal([], @room_info.get_categories_for_area("Dorms"), "Testing area with no categories.")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.new_category("Dorms", "Structural")
    @room_info.save!
    assert_equal(["Furniture", "Structural"], @room_info.get_categories_for_area("Dorms"), "Testing that some categories show up")
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_category("Quads", "Furniture")
    @room_info.new_category("Quads", "Windows")
    @room_info.save!
    assert_equal(["Furniture", "Windows", "Structural"], @room_info.get_categories_for_area("Quads"), "Testing that parent-child relationships resolve correctly.")
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception.") {@room_info.get_categories_for_area("Foo")}
  end

  def test_get_items_for_category_in_area()
    @room_info.new_area("Dorms")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.new_category("Dorms", "Structural")
    @room_info.new_item("Dorms", "Furniture", "Bed", "What you sleep in")
    @room_info.new_item("Dorms", "Structural", "Ceiling", "The thing over your head")
    @room_info.save!
    assert_equal([{name: "Bed", description: "What you sleep in"}], @room_info.get_items_for_category_in_area("Dorms", "Furniture"), "Testing adding items")
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_category("Quads", "Furniture")
    @room_info.new_category("Quads", "Windows")
    @room_info.new_item("Quads", "Furniture", "Dresser", "Er Dress")
    @room_info.new_item("Quads", "Windows", "Blinds", "Can't see them")
    @room_info.save!
    assert_equal([{name: "Dresser", description: "Er Dress"}, {name: "Bed", description: "What you sleep in"}], @room_info.get_items_for_category_in_area("Quads", "Furniture"), "Testing that parent-child relationshis resolve")
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception.") {@room_info.get_items_for_category_in_area("Foo", "Furniture")}
  end

  def test_get_items_for_area()
    @room_info.new_area("Dorms")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.new_category("Dorms", "Structural")
    @room_info.new_item("Dorms", "Furniture", "Bed", "What you sleep in")
    @room_info.new_item("Dorms", "Structural", "Ceiling", "The thing over your head")
    @room_info.save!
    assert_equal([{name: "Bed", description: "What you sleep in", category: "Furniture"}, {name: "Ceiling", description: "The thing over your head", category: "Structural"}], @room_info.get_items_for_area("Dorms"), "Testing adding items")
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_category("Quads", "Furniture")
    @room_info.new_category("Quads", "Windows")
    @room_info.new_item("Quads", "Furniture", "Dresser", "Er Dress")
    @room_info.new_item("Quads", "Windows", "Blinds", "Can't see them")
    @room_info.save!
    assert_equal([{name: "Dresser", description: "Er Dress", category: "Furniture"}, {name: "Bed", description: "What you sleep in", category: "Furniture"}, {name: "Blinds", description: "Can't see them", category: "Windows"}, {name: "Ceiling", description: "The thing over your head", category: "Structural"}], @room_info.get_items_for_area("Quads"), "Testing that parent-child relationshis resolve")
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception.") {@room_info.get_items_for_area("Foo")}
  end

  def test_new_room_assignment()
    @room_info.new_area("Dorms")
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_room_assignment("NQ", "201-316, 401-410, 414, 416", "Quads")
    assert_equal([{building: "NQ", rooms: "201-316, 401-410, 414, 416", area: "Quads"}], @room_info.config[:rooms], "Testing adding rooms")
    assert_raise(RuntimeError, "Testing that non-existant area raises exception.") {@room_info.new_room_assignment("Foo", "100-300", "Bar")}
  end

  def test_get_area_for_room()
    @room_info.new_area("Dorms")
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_room_assignment("NQ", "201-316, 401-410, 414, 416", "Quads")
    assert_equal("Quads", @room_info.get_area_for_room("NQ", 210), "Testing room in range")
    assert_raise(RuntimeError, "Testing undefined room") {@room_info.get_area_for_room("NQ", 415)} 
  assert_raise(RuntimeError, "Testing undefined building") {@room_info.get_area_for_room("EQ", 100)}
  end

  def test_get_items_for_room()
    @room_info.new_area("Dorms")
    @room_info.new_category("Dorms", "Furniture")
    @room_info.new_category("Dorms", "Structural")
    @room_info.new_item("Dorms", "Furniture", "Bed", "What you sleep in")
    @room_info.new_item("Dorms", "Structural", "Ceiling", "The thing over your head")
    @room_info.save!
    @room_info.new_area("Quads", "Dorms")
    @room_info.new_category("Quads", "Furniture")
    @room_info.new_category("Quads", "Windows")
    @room_info.new_item("Quads", "Furniture", "Dresser", "Er Dress")
    @room_info.new_item("Quads", "Windows", "Blinds", "Can't see them")
    @room_info.save!
    @room_info.new_room_assignment("NQ", "201-316, 401-410, 414, 416", "Quads")
    assert_equal([{name: "Dresser", description: "Er Dress", category: "Furniture"}, {name: "Bed", description: "What you sleep in", category: "Furniture"}, {name: "Blinds", description: "Can't see them", category: "Windows"}, {name: "Ceiling", description: "The thing over your head", category: "Structural"}], @room_info.get_items_for_room("NQ", 405), "Testing that parent-child relationshis resolve")
    assert_raise(RuntimeError, "Testing that a non-existant area raises an exception.") {@room_info.get_items_for_room("Foo", 46)}
  end
end
