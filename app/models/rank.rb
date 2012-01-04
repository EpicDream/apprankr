class Rank < ActiveRecord::Base
  belongs_to :application
  belongs_to :ranking
  validates :application, :presence => true
  validates :ranking, :presence => true
  validates :rank, :presence => true, :numericality => { :only_integer => true }
end
