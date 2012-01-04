class CreateWhatsnews < ActiveRecord::Migration
  def self.up
    create_table :whatsnews do |t|
      t.integer :application_id
      t.integer :language_id
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :whatsnews
  end
end
