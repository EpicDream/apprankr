class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.integer :category_id
      t.integer :country_id
      t.integer :ranking_type_id
      t.timestamps
    end
    add_index :rankings, [:category_id, :country_id, :ranking_type_id], :unique => true, :name => "idx_ranking"
  end

  def self.down
    remove_index :rankings, [:category_id, :country_id, :ranking_type_id], :unique => true
    drop_table :rankings
  end
end
