class Country < ActiveRecord::Base
  belongs_to :language
  validates :language, :presence => true
  
  scope :france, where(:name => 'France')
  
end
