require 'yaml'

##
# Uses a YAML configuration file to determine
# what RoomItems Belong on a room's RCR.
class RoomInfo
  def initialize(configuration_file)
    @configuration_file = configuration_file
    FileUtils.touch(configuration_file)
    File.open(configuration_file, 'r') {|f| @config = YAML::load(f)}
    @config = {areas: [], rooms: []} unless @config
    @area_config = @config[:areas]
    @room_config = @config[:rooms]
  end

  attr_reader :config

  def save!()
    @config[:areas] = @area_config
    @config[:rooms] = @room_config
    File.open(@configuration_file, 'w+') {|f| YAML::dump(@config, f)}
  end

  def reload!()
    File.open(@configuration_file, 'r') {|f| @config = YAML::load(f)}
    @area_config = @config[:areas]
    @room_config = @config[:rooms]
  end
  
  def new_area(name, parent = nil)
    @area_config << {name: name, parent: parent, categories: []}
  end

  def new_category(area_name, name)
    area = @area_config.index {|i| i[:name] == area_name}
    raise "Area does not exist!" unless area
    @area_config[area][:categories] << {name: name, items: []}
  end

  def new_item(area_name, category_name, name, description)
    area = @area_config.index {|i| i[:name] == area_name}
    raise "Area does not exist!" unless area
    category = @area_config[area][:categories].index {|i| i[:name] == category_name}
    raise "Category does not exist in this area!" unless category
    @area_config[area][:categories][category][:items] << {name: name, description: description}
  end

  def get_areas()
    areas = []
    @area_config.each {|area| areas << area[:name]}
    return areas
  end

  def get_categories_for_area(area_name)
    categories = []
    area = @area_config.index {|i| i[:name] == area_name}
    raise "Area does not exist!" unless area
    @area_config[area][:categories].each {|category| categories << category[:name]}
    categories = categories | self.get_categories_for_area(@area_config[area][:parent]) if @area_config[area][:parent]
    return categories
  end

  def get_items_for_category_in_area(area_name, category_name)
    area = @area_config.index {|i| i[:name] == area_name}
    raise "Area does not exist!" unless area
    category = @area_config[area][:categories].index {|i| i[:name] == category_name}
    if category
      items = @area_config[area][:categories][category][:items]
    else
      items = []
    end
    items = items | self.get_items_for_category_in_area(@area_config[area][:parent], category_name) if @area_config[area][:parent]
    return items
  end

  def get_items_for_area(area_name)
    items = []
    categories = self.get_categories_for_area(area_name)
    categories.each {|category| items = items | self.get_items_for_category_in_area(area_name, category).each {|item| item[:category] = category}}

    return items
  end
  
  def new_room_assignment(building, rooms, area_name)
    raise "Area not found" unless self.get_areas.index(area_name)
    @room_config << {building: building, rooms: rooms, area: area_name}
  end
  
  def get_area_for_room(building, room_number)
    area = nil
    @room_config.each do |config|
      if config[:building] == building
        rooms = []
        config[:rooms].split(/\s*,\s*/).each do |section|
          if section.match(/[0-9]+-[0-9]+/)
            section = section.split('-')
            (section[0].to_i..section[1].to_i).each {|i| rooms << i}
          else
            rooms << section.to_i if section.match(/[0-9]+.*/)
          end
        end
        rooms.each {|room| area = config[:area] if room == room_number}
      end
    end
    return area if area
    raise "No assignment defined for room"
  end
  
  def get_items_for_room(building, room_number)
    area = self.get_area_for_room(building, room_number)
    return self.get_items_for_area(area)
  end
end
