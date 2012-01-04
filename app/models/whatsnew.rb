class Whatsnew < ActiveRecord::Base
  belongs_to :application
  belongs_to :language
  validates :application, :presence => true
  validates :language, :presence => true
  validates :content, :presence => true, :length => { :minimum => 3 }
end
