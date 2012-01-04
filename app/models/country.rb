class Country < ActiveRecord::Base
  belongs_to :language
  validates :language, :presence => true
end
