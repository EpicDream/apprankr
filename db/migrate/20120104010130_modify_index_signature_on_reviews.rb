class ModifyIndexSignatureOnReviews < ActiveRecord::Migration
  def self.up
    remove_index :reviews, :signature
    add_index :reviews, [:application_id, :signature], :unique => true
  end

  def self.down
  end
end
