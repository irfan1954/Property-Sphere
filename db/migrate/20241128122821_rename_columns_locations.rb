class RenameColumnsLocations < ActiveRecord::Migration[7.1]
  def change
    rename_column :locations, :average_rent, :rent_price
    rename_column :locations, :average_sale_price, :purchase_price
  end
end
