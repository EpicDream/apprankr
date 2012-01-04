class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :application_id
      t.integer :country_id
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
