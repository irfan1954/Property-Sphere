class AddContactedToSavedProperties < ActiveRecord::Migration[7.1]
  def change
    add_column :saved_properties, :contacted, :boolean
  end
end
