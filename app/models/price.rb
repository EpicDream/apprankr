class Price < ActiveRecord::Base
  belongs_to :application
  belongs_to :country
  validates :application, :presence => true
  validates :country, :presence => true
  validates :value, :presence => true
end
