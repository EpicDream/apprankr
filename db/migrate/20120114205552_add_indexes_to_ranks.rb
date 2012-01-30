class AddIndexesToRanks < ActiveRecord::Migration
  def self.up
    add_index :ranks, [:application_id, :created_at]
  end

  def self.down
    remove_index :ranks, [:application_id, :created_at]
  end
end
