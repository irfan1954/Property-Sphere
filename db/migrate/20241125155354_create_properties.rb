class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.text :street_address
      t.string :postcode
      t.text :description
      t.integer :bedrooms
      t.integer :bathrooms
      t.boolean :garden
      t.text :image_urls, array: true, default: []
      t.string :council_tax
      t.string :type
      t.float :floor_area
      t.references :postcode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
