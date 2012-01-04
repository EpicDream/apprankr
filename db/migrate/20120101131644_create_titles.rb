class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles do |t|
      t.integer :application_id
      t.integer :language_id
      t.string :content
      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
