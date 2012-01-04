class CreateReviewSummaries < ActiveRecord::Migration
  def self.up
    create_table :review_summaries do |t|
      t.integer :application_id
      t.integer :star5
      t.integer :star4
      t.integer :star3
      t.integer :star2
      t.integer :star1
      t.timestamps
    end
  end

  def self.down
    drop_table :review_summaries
  end
end
