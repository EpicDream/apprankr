class ReviewSummary < ActiveRecord::Base
  belongs_to :application
  validates :star1, :presence => true, :numericality => { :only_integer => true }
  validates :star2, :presence => true, :numericality => { :only_integer => true }
  validates :star3, :presence => true, :numericality => { :only_integer => true }
  validates :star4, :presence => true, :numericality => { :only_integer => true }
  validates :star5, :presence => true, :numericality => { :only_integer => true }
  
  def rating
    (self.star1 + self.star2*2 + self.star3*3 + self.star4*4 + self.star5*5).to_f / self.count
  end
  
  def count
    self.star1 + self.star2 + self.star3 + self.star4 + self.star5
  end
  
end
