class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
