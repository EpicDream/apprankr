class Ranking < ActiveRecord::Base
  belongs_to :country
  belongs_to :category
  belongs_to :ranking_type
  has_many :ranks
end
