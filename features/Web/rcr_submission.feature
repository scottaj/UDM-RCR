Feature: Users should be able to submit an RCR

	  Scenario: I should be see a list of available categories for my RCR
	  	    Given I am on the home page
		    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		    When I log in with the token "abc123"
		    And I follow "Yes" within "#confirm"
		    Then I should be on the RCR page
		    And I should see "Structural" within "#categories"
		    And I should see "Furniture" within "#categories"
		    And I should see "Bathroom" within "#categories"