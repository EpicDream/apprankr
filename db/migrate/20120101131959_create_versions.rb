class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :application_id
      t.string :value
      t.string :size
      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
