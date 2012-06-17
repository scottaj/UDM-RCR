Feature: Token Login
	 Users should be able to log on to compete their RCR's
	 using randomly generated personalized tokens.

	 Scenario: A token for the current term should allow the user to view their RCR.
	 	   Given I am on the home page
		   And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		   When I fill in "token" with "abc123" within "#token-login"
		   And I press "Go!" within "#token-login"
		   Then I should be on the confirmation page
		   And I should see "Confirm Personal Information"
		   And I should see "Jane Doe"
		   And I should see "East Quad 210"

	 Scenario: A non existant token should get a an error message
	 	   Given I am on the home page
	 	   And there is no RCR with the token "a1b2c3"
		   When I fill in "token" with "a1b2c3" within "#token-login"
		   And I press "Go!" within "#token-login"
		   Then I should be on the home page
		   And I should see "Token not found!" within "#token-login"
		   
	 Scenario: Clicking on the help link on the token page
	 	   Given I am on the home page
		   When I follow "Having trouble with your token?"
		   Then I should be on the token help page