class CreateApplicationCategories < ActiveRecord::Migration
  def self.up
    create_table :application_categories do |t|
      t.integer :application_id
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :application_categories
  end
end
