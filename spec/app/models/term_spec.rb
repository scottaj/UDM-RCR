require 'spec_helper'

describe "Term" do

  after do
    Term.destroy_all
  end
  
  describe "Creating and updating terms" do

    before do
      @term = Term.create(name: "term1",
                          start_date: Date.new(2008, 4, 16),
                          end_date: Date.new(2008, 5, 7))
    end
    
    it "should not allow two terms to exist for the same date." do      
      lambda {Term.create(name: "term2",
                     start_date: Date.new(2008, 5, 1),
                     end_date: Date.new(2008, 5, 14))}.should raise_error(TermError)      
    end

    it "should not allow two terms to have the same case-insensative name." do
      lambda {Term.create(name: "TERM1",
                     start_date: Date.new(2005, 4, 16),
                     end_date: Date.new(2005, 5, 7))}.should raise_error(TermError)
    end

    it "should not allow a term to have an end date before its start date." do
      lambda {Term.create(name: "weird term",
                     start_date: Date.new(2009, 4, 21),
                     end_date: Date.new(2009, 2, 7))}.should raise_error(TermError)
    end
  end
  
  describe "Finding the currently active term" do
    it "should find the active term for the current date if there is one." do
      Term.create(name: "test1",
                  start_date: Date.today - 200,
                  end_date: Date.today - 150)
      Term.create(name: "test2",
                  start_date: Date.today - 10,
                  end_date: Date.today + 10)
      Term.create(name: "test3",
                  start_date: Date.today - 25,
                  end_date: Date.today - 15)
      
      Term.active_term.name.should == "test2"
    end
    
    it "should find the nearest term to the current calandar date if there is none active for the current date." do
      Term.create(name: "test1",
                  start_date: Date.today - 200,
                  end_date: Date.today - 150)
      Term.create(name: "test2",
                  start_date: Date.today - 25,
                  end_date: Date.today - 10)
      Term.create(name: "test3",
                  start_date: Date.today - 100,
                  end_date: Date.today - 50)

      Term.active_term.name.should == "test2"
    end
    
    it "should return nil if there are no terms defined" do
      Term.active_term.should be_nil
    end
  end
end
