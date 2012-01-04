class Review < ActiveRecord::Base
  belongs_to :application
  belongs_to :language
  validates :application, :presence => true
  validates :language, :presence => true
  validates :title, :presence => true
  validates :signature, :presence => true
  validates :rating, :presence => true, :numericality => { :only_integer => true }
end
