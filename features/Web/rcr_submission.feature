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

	  Scenario: I should see the name of the category in the URL on the page
	  	    Given I am on the home page
		    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		    When I log in with the token "abc123"
		    And I follow "Yes" within "#confirm"
		    Then I should see the "category" parameter on the page within "#center"
		    

	  Scenario: I should see each item in the current category on the page
	  	    Given I am on the home page
		    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		    When I log in with the token "abc123"
		    And I follow "Yes" within "#confirm"
		    Then I should see the each item in the "category" parameter on the page within "#center"
		    And I should not see items that are not in the "category" parameter within "#center"

	  Scenario: I should be able to rate each item on the page
	  	    Given I am on the home page
		    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		    When I log in with the token "abc123"
		    And I follow "Yes" within "#confirm"
		    Then I should be able to rate each item
		    And I should be able to add a comment for each rating
		    And clicking "Next", "Previous", or "Submit" within "#continue" should save my ratings to the database

	  Scenario: I should be able to jump to any category by clicking its link in the categories box

	  Scenario: I should be able to leave a page and return to it having the same state