class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.integer :application_id
      t.integer :ranking_id
      t.integer :rank
      t.timestamps
    end
  end

  def self.down
    drop_table :ranks
  end
end
