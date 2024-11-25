class CreatePostcodes < ActiveRecord::Migration[7.1]
  def change
    create_table :postcodes do |t|
      t.string :postcode
      t.string :borough
      t.string :layer_code
      t.float :lat
      t.float :long
      t.float :crime
      t.integer :average_rent
      t.integer :average_sale_price

      t.timestamps
    end
  end
end
