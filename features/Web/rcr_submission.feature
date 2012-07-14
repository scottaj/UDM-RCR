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
        
  @javascript
  Scenario: I should be able to rate each item on the page
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes" within "#confirm"
    Then I should be able to rate each item
    And I should be able to add a comment for each rating
    When I rate each item "5" within "#center"
    And I comment each item "Comment Here" within "#center"
    Then clicking "Next", "Previous", "Submit" within "#continue" should save my ratings to the database

  Scenario: I should be able to jump to any category by clicking its link in the categories box
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes" within "#confirm"
    Then I should be on the RCR page
    When I follow "Structural" within "#categories"
    Then the "category" parameter should be "Structural"
    When I follow "Furniture" within "#categories"
    Then the "category" parameter should be "Furniture"      

  @javascript  
  Scenario: I should be able to go to navigate between categories using "Next" and "Previous"
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes" within "#confirm"
    Then I should be on the RCR page
    And the "category" parameter should be saved
    When I press "Next" within "#continue"
    Then the "category" parameter should be different than the one I saved
    When I press "Previous" within "#continue"
    Then the "category" parameter should be the same as the one I saved

  @javascript
  Scenario: Pressing "submit" should cause an RCR to be validated as complete and give a message if it isn't
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes" within "#confirm"
    And I rate each item "5" within "#center"
    And I comment each item "Comment Here" within "#center"
    And I press "Next"
    And I wait "3" seconds
    And I press "Next"
    And I wait "3" seconds
    And I rate each item "5" within "#center"
    And I comment each item "Comment Here" within "#center" 
    And I submit the RCR
    And I wait "3" seconds
    Then I should be on the RCR page
    And the RCR with token "abc123" should be marked as incomplete
    When I press "Previous"
    And I wait "3" seconds
    And I rate each item "5" within "#center"
    And I comment each item "Comment Here" within "#center"
    And I press "Next"
    And I submit the RCR
    And I wait "3" seconds
    Then I should be on the Submission confirmation page
    And the RCR with token "abc123" should be marked as complete
    
    
  Scenario: Trying to submit an RCR for a room with no assignment should go to an error page
    

    
  Scenario: Pressing "submit" should mark an RCR complete and lock it for further editing

  Scenario: I should be able to leave a page and return to it having the same state
