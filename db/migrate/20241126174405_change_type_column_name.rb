class ChangeTypeColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :amenities, :type, :amenity_type
  end
end
