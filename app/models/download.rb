class Download < ActiveRecord::Base
  belongs_to :application
  validates :application, :presence => true
  validates :value, :presence => true
end
