Feature: Identity confirmation
	 To ensure that users are filling out the correct RCR, they should confirm their identity after they log in.

	 Scenario: A user logs in and their identity is correct.
	 	   Given I am on the home page
		   And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		   When I log in with the token "abc123"
		   Then I should be on the confirmation page
		   When I follow "Yes" within "#confirm"
		   Then I should be on the RCR page
		   And I should see "Jane Doe"
		   And I should see "East Quad 210"

	 Scenario: A user logs in and their identity is incorrect
	 	   Given I am on the home page
		   And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
		   When I log in with the token "abc123"
		   Then I should be on the confirmation page
		   When I follow "No" within "#confirm"
		   Then I should be on the confirmation help page