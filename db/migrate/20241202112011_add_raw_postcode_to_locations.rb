class AddRawPostcodeToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :raw_postcode, :string
  end
end
