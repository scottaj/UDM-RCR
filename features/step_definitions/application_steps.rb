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
    return AreaMapping.get_items_for_room("East Quad", 210).keep_if do |item|
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
  @rcr = RCR.create(token: token,
                    first_name: first_name,
                    last_name: last_name,
                    email: "",
                    building: building,
                    room_number: room,
                    complete: false,
                    term: Term.current_term)
end

Given /^the RCR with token "(.*?)" is marked complete$/ do |token|
  rcr = RCR.where(token: @rcr.token).first
  rcr.complete = true
  rcr.save
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

When /^I wait "(\d+?)" seconds$/ do |time|
  sleep(time.to_f)
end

When /^I submit the RCR$/ do
  page.driver.accept_js_confirms!
  page.click_button("Submit")
end

Then /^the RCR with token "(.*?)" should be marked as complete$/ do |token|
  RCR.find_by(token: token).complete?.should be_true
end

Then /^the RCR with token "(.*?)" should be marked as incomplete$/ do |token|
  RCR.find_by(token: token).complete?.should be_false
end

Then /^the "(.*?)" parameter should be "(.*?)"$/ do |param, value|
  get_param_value(param, current_url).should == value
end

Then /^the "(.*?)" parameter should be saved$/ do |param|
  @parameter_value = get_param_value(param, current_url)
  @parameter_value.should be_true
end

Then /^the "(.*?)" parameter should be different than the one I saved$/ do |param|
  sleep(5) # Sleep so that the page has time to change from the
  # previous step
  get_param_value(param, current_url).should_not == @parameter_value
end

Then /^the "(.*?)" parameter should be the same as the one I saved$/ do |param|
  sleep(5) # sleep so that the page has time to change from the
  # previous step
  get_param_value(param, current_url).should == @parameter_value
end

Then /^there is no RCR with the token "(.*?)"$/ do |token|
  Term.current_term.rcrs.find_by(token: token).should be_nil
end

Then /^I should see the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  with_scope(selector) do
    page.should have_content(param_value) if param_value
  end
end

Then /^I should see the each item in the "(.*?)" parameter on the page(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  items = get_items_on_page(param_value)
  with_scope(selector) do
    items.each do |item|
      page.should have_content(item[:name])
    end
  end
end

Then /^I should not see items that are not in the "(.*?)" parameter(?: within "([^\"]*)")?$/ do |param, selector|
  param_value = get_param_value(param, current_url)
  bad_items = AreaMapping.get_items_for_room("East Quad", 210).delete_if do |item|
    item[:category] == param_value
  end
   with_scope(selector) do
    bad_items.each do |item|
      page.should_not have_content(item[:name])
    end
  end
end


Then /^I should be able to rate each item$/ do
  page.find('.item').should have_selector('select')
end

Then /^I should be able to add a comment for each rating$/ do
  page.find('.item').should have_selector('textarea')
end

Then /^clicking (".+")(?: within "([^\"]*)")? should save my ratings to the database$/ do |labels, selector|
  found = find_which_button(labels, selector)
  if found
    items_on_page = get_items_on_page(get_param_value("category", current_url))
    with_scope(selector) do
      page.click_button(found)
    end
    sleep(3) # wait for ajax request to update rcr.
    rcr = Term.current_term.rcrs.find_by(token: @rcr.token)  
    items_on_page.each {|item| rcr.room_items.find_by(name: item[:name]).should be_true}
  else
    raise "Button not found!"
  end  
end

Then /^each item should be unrated$/ do
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  items.each do |item|
    find_field("#{item[:name]}-rating").value.should == "0"
  end
end

Then /^each item should be uncommented$/ do
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  items.each do |item|
    find_field("#{item[:name]}-comment").value.length.should == 0
  end
end

Then /^each item should be rated "(.*?)"$/ do |rating|
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  items.each do |item|
    find_field("#{item[:name]}-rating").value.should =~ /#{rating}/i
  end
end

Then /^each item should have the comment "(.*?)"$/ do |comment|
  param_value = get_param_value("category", current_url)
  items = get_items_on_page(param_value)
  items.each do |item|
    find_field("#{item[:name]}-comment").value.should =~ /#{comment}/i
  end
end
