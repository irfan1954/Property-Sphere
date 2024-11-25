class CreateAmenities < ActiveRecord::Migration[7.1]
  def change
    create_table :amenities do |t|
      t.string :type
      t.string :name
      t.float :lat
      t.float :long
      t.references :postcode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
