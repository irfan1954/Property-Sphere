class AddPriceAndFreeholdToProperty < ActiveRecord::Migration[7.1]
  def change
    add_column :properties, :price, :integer
    add_column :properties, :freehold, :string
  end
end
