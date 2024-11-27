class RenameAmenityTypetoCategory < ActiveRecord::Migration[7.1]
  def change
    rename_column :amenities, :amenity_type, :category
  end
end
