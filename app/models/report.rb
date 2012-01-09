class Report < ActiveRecord::Base
  belongs_to :application
  validates :application, :presence => true
  validates :stat, :presence => true
  validates :value, :presence => true, :numericality => { :only_integer => true }
  
  DOWNLOADED = 1
  INSTALLED = 2
  
end
