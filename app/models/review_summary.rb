class ReviewSummary < ActiveRecord::Base
  belongs_to :application
  validates :star1, :presence => true, :numericality => { :only_integer => true }
  validates :star2, :presence => true, :numericality => { :only_integer => true }
  validates :star3, :presence => true, :numericality => { :only_integer => true }
  validates :star4, :presence => true, :numericality => { :only_integer => true }
  validates :star5, :presence => true, :numericality => { :only_integer => true }
end
