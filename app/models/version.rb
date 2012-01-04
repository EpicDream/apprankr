class Version < ActiveRecord::Base
  belongs_to :application
  validates :application, :presence => true
  validates :value, :presence => true
  validates :size, :presence => true
end
