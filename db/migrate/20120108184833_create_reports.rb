class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :application_id
      t.integer :stat
      t.integer :value
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
