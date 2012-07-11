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

  def get_items_on_page(category_name)
    return @room_info.get_items_for_room("East Quad", 210).keep_if do |item|
      item[:category] == category_name
    end
  end
  
  def find_which_button(labels, selector)
    labels = labels.split(/,\s*/)
    found = nil
    with_scope(selector) do
      labels.each do |label|
        label = label[/\w+/]
        found = label if page.has_button?(label)
      end
    end
    return found
  end
end
World(AppCukeHelpers)

Given /^an RCR with token "(.*?)" exists for "(.*?)\s(.*?)" in room "(.*?)" of the building "(.*?)"$/ do |token, first_name, last_name, room, building|
  @rcr = RCR.create(token: "abc123",
             term_year: @term[:year],
             term_name: @term[:term],
             first_name: first_name,
             last_name: last_name,
             email: "",
             building: building,
             room_number: room,
             complete: false)
end

When /^I log in with the token "(.*?)"$/ do |token|
  visit '/'
  fill_in("token", with: token)
  click_button("Go!")
end

When /^I rate each item "(.*?)"(?: within "([^\"]*)")?$/ do |rating, selector|
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  with_scope(selector) do
    items.each do |item|
      page.select(rating, from: "#{item[:name]}-rating")
    end
  end
end

When /^I comment each item "(.*?)"(?: within "([^\"]*)")?$/ do |comment, selector|
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  with_scope(selector) do
    items.each do |item|
      page.fill_in("#{item[:name]}-comment", with: comment)
    end
  end
end

Then /^the "(.*?)" parameter should be "(.*?)"$/ do |param, value|
  param_value = get_param_value(param, current_url)
  assert_equal(param_value, value)
end

Then /^there is no RCR with the token "(.*?)"$/ do |token|
  assert_equal(false, RCR.token_exists_for_term?(token, @term[:year], @term[:term]))
end

Then /^I should see the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  with_scope(selector) do
    assert(page.has_content?(param_value)) if param_value
  end
end

Then /^I should see the each item in the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  items = get_items_on_page(param_value)
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


Then /^I should be able to rate each item$/ do
  assert(page.find('.item').has_selector?('select'))
end

Then /^I should be able to add a comment for each rating$/ do
  assert(page.find('.item').has_selector?('textarea'))
end

Then /^clicking (".+") within "(.*?)" should save my ratings to the database$/ do |labels, selector|
  found = find_which_button(labels, selector)
  if found
    with_scope(selector) do
      page.click_button(found)
    end
    sleep(2) # wait for ajax request to update rcr.
    rcr = RCR.where(token: @rcr.token).first  
    items_on_page = get_items_on_page(get_param_value("category", current_url))
    items_on_page.each {|item| assert(rcr.room_items.where(name: item[:name]).first, "Item \"#{item[:name]}\" not saved.")}
  else
    raise "Button not found!"
  end  
end
