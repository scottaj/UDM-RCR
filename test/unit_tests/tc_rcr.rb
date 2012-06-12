require 'bundler/setup'
require 'mongoid'

Mongoid.configure do |config|
  name = "rcr_app_testing"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end

require_relative '../../lib/rcr'
require 'test/unit'

class TestRCR < Test::Unit::TestCase
  def setup()
    
  end

  def teardown()
    Mongoid.purge!
  end

  
  def test_token_exists_for_term()
    rcrs = []
    rcrs << RCR.create(token: rand(36**6).to_s(36),
               term_year: 2012,
               term_name: "fall",
               first_name: "Joe",
               last_name: "Sixpack",
               email: "jsp@example.com",
               building: "Shiple",
               room_number: 101,
               complete: false)
    rcrs << RCR.create(token: rand(36**6).to_s(36),
               term_year: 2012,
               term_name: "fall",
               first_name: "Phil",
               last_name: "Wizzle",
               email: "pwiz@example.com",
               building: "Shiple",
               room_number: 103,
               complete: false)
    assert(RCR.token_exists_for_term?(rcrs[0].token, 2012, "fall"))
    assert_equal(false, RCR.token_exists_for_term?(rcrs[1].token, 2013, "fall"))
    assert_equal(false, RCR.token_exists_for_term?(rcrs[1].token, 2012, "winter"))
    assert_equal(false, RCR.token_exists_for_term?(rand(36**6).to_s(36), 2012, "fall"))
  end
end
