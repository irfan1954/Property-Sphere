class ChangeCreatedDefaultInSavedProperties < ActiveRecord::Migration[7.1]
  def change
    change_column_default :saved_properties, :contacted, from: nil, to: false
  end
end
