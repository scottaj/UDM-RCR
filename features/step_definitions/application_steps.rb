require 'uri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

module AppCukeHelpers
  def get_param_value(param, url)
    uri = URI.parse(url)
    param_value = nil
    parsed_param = uri.query.split("&").each do |kv_pair|
      kv_pair = kv_pair.split("=")
      param_value = kv_pair[1] if kv_pair[0] == param
    end
    return param_value
  end
end
World(AppCukeHelpers)

Given /^an RCR with token "(.*?)" exists for "(.*?)\s(.*?)" in room "(.*?)" of the building "(.*?)"$/ do |token, first_name, last_name, room, building|
  RCR.create(token: "abc123",
             term_year: @term[:year],
             term_name: @term[:term],
             first_name: first_name,
             last_name: last_name,
             email: "",
             building: building,
             room_number: room,
             complete: false)
end

Then /^there is no RCR with the token "(.*?)"$/ do |token|
  assert_equal(false, RCR.token_exists_for_term?(token, @term[:year], @term[:term]))
end

When /^I log in with the token "(.*?)"$/ do |token|
  visit '/'
  fill_in("token", with: token)
  click_button("Go!")
end

Then /^I should see the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  with_scope(selector) do
    assert(page.has_content?(param_value)) if param_value
  end
end

Then /^I should see the each item in the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  items = @room_info.get_items_for_room("East Quad", 210).keep_if do |item|
    item[:category] == param_value
  end
  with_scope(selector) do
    items.each do |item|
      assert(page.has_content?(item[:name]))
    end
  end
end

Then /^I should not see items that are not in the "(.*?)" parameter within "(.*?)"$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  bad_items = @room_info.get_items_for_room("East Quad", 210).delete_if do |item|
    item[:category] == param_value
  end
   with_scope(selector) do
    bad_items.each do |item|
      assert_equal(false, page.has_content?(item[:name]))
    end
  end
end


