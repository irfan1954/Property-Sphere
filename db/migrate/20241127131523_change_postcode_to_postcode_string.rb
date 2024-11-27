class ChangePostcodeToPostcodeString < ActiveRecord::Migration[7.1]
  def change
    rename_column :properties, :postcode, :postcode_string
  end
end
