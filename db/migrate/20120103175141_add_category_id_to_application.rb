class AddCategoryIdToApplication < ActiveRecord::Migration
  def self.up
    add_column :applications, :category_id, :integer
  end

  def self.down
   remove_column :applications, :category_id
  end
end
