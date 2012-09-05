Feature: Users should be able to submit an RCR
  
  Scenario: I should be see a list of available categories for my RCR
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should be on the RCR page
    And I should see "Structural"  
    And I should see "Furniture"  
    And I should see "Bathroom"  

  Scenario: I should see the name of the category in the URL on the page
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should see the "category" parameter on the page  
      

  Scenario: I should see each item in the current category on the page
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should see the each item in the "category" parameter on the page  
    And I should not see items that are not in the "category" parameter  
        
  @javascript
  Scenario: I should be able to rate each item on the page
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should be able to rate each item
    And I should be able to add a comment for each rating
    When I rate each item "Good"  
    And I comment each item "Comment Here"  
    Then clicking "Next", "Previous", "Submit" should save my ratings to the database  

  Scenario: I should be able to jump to any category by clicking its link in the categories box
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should be on the RCR page
    When I follow "Structural"  
    Then the "category" parameter should be "Structural"
    When I follow "Furniture"  
    Then the "category" parameter should be "Furniture"      

  @javascript  
  Scenario: I should be able to go to navigate between categories using "Next" and "Previous"
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    Then I should be on the RCR page
    And the "category" parameter should be saved
    When I press "Next"  
    Then the "category" parameter should be different than the one I saved
    When I press "Previous"  
    Then the "category" parameter should be the same as the one I saved

  @javascript
  Scenario: Pressing "submit" should cause an RCR to be validated as complete and give a message if it isn't
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"  
    And I rate each item "Good"  
    And I comment each item "Comment Here"  
    And I press "Next"
    And I wait "3" seconds
    And I press "Next"
    And I wait "3" seconds
    And I rate each item "Good"  
    And I comment each item "Comment Here"  
    And I submit the RCR
    And I wait "3" seconds
    Then I should be on the RCR page
    And the RCR with token "abc123" should be marked as incomplete
    When I press "Previous"
    And I wait "3" seconds
    And I rate each item "Good"  
    And I comment each item "Comment Here"  
    And I press "Next"
    And I submit the RCR
    And I wait "3" seconds
    Then I should be on the Submission confirmation page
    And the RCR with token "abc123" should be marked as complete
    
  Scenario: Submitting an RCR should lock it from further editing.
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    And the RCR with token "abc123" is marked complete
    When I log in with the token "abc123"
    Then I should be on the home page
    And I should see "RCR Already Completed!"

  @javascript  
  Scenario: I should be able to leave a page and return to it having the same state
    Given I am on the home page
    And an RCR with token "abc123" exists for "Jane Doe" in room "210" of the building "East Quad"
    When I log in with the token "abc123"
    And I follow "Yes"
    Then each item should be unrated
    And each item should be uncommented
    When I rate each item "Good"
    And I comment each item "Comment Here"
    And I press "Next"
    And I wait "3" seconds
    And I press "Previous"
    And I wait "3" seconds
    Then each item should be rated "3"
    And each item should have the comment "Comment Here"
