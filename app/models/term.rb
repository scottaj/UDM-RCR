class TermError < StandardError
end

class Term
  include Mongoid::Document
  
  field :name, type: String
  field :start_date, type: Date
  field :end_date, type: Date
  has_many :rcrs, class_name: "RCR"

  def check_for_conflicting_term_dates()
    subquery1 = Term.between(start_date: self.start_date..self.end_date)
    subquery2 = Term.between(end_date: self.start_date..self.end_date)
    msg = "Dates in term conflict with an existing term."
    raise(TermError, msg) unless subquery1.empty? and subquery2.empty?
  end

  def check_for_conflicting_term_names()
    query = Term.where(name: /^#{self.name}$/i)
    msg = "The name of this term conflicts with an existing term"
    raise(TermError, msg) unless query.empty?
  end

  def check_for_end_before_start()
    msg = "This term has an end date that is after its start date."
    raise(TermError, msg) if self.end_date < self.start_date
  end
  
  before_save do
    check_for_conflicting_term_dates
    check_for_conflicting_term_names
    check_for_end_before_start
  end

  def self.active_term()
    query = self.and(:start_date.lte => Date.today, :end_date.gte => Date.today)
    i = 1
    while query.empty? and not self.all.empty?
      query = self.between(start_date: (Date.today - i)..(Date.today + i))
      i += 1
    end

    return query.first
  end
end
