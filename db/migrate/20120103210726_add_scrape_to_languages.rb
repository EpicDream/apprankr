class AddScrapeToLanguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :scrape, :boolean, :default => false 
  end

  def self.down
    remove_column :languages, :scrape
  end
end
