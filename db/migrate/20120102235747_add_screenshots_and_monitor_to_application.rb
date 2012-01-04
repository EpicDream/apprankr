class AddScreenshotsAndMonitorToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :screenshots, :text
    add_column :applications, :monitor, :boolean, :null => false, :default => 'f'
  end
end
