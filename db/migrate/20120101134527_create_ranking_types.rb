class CreateRankingTypes < ActiveRecord::Migration
  def self.up
    create_table :ranking_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :ranking_types
  end
end
