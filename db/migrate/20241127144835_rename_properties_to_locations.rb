class RenamePropertiesToLocations < ActiveRecord::Migration[7.1]
  def change
    rename_table :postcodes, :locations
  end
end
