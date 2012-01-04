class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.string :package, :unique => true
      t.string :developer
      t.string :website
      t.string :email
      t.string :icon
      t.string :video
      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
