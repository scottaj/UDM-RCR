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
