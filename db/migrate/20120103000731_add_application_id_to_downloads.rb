class AddApplicationIdToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :application_id, :integer
  end
end
