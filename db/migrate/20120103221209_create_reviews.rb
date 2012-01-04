class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :application_id
      t.integer :language_id
      t.string :signature
      t.string :author
      t.string :title
      t.text :content
      t.integer :rating
      t.timestamps
    end
    add_index :reviews, :application_id
    add_index :reviews, :signature, :unique => true
  end

  def self.down
    remove_index :reviews, :application_id
    remove_index :reviews, :signature
    drop_table :reviews
  end
end
