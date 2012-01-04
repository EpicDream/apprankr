class CreateApplicationDownloads < ActiveRecord::Migration
  def self.up
    create_table :application_downloads do |t|
      t.integer :application_id
      t.integer :download_id
      t.timestamps
    end
  end

  def self.down
    drop_table :application_downloads
  end
end
