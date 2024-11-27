class AmendForeignKeysAndColumns < ActiveRecord::Migration[7.1]
  def change
    change_table :properties do |t|
      t.remove :postcode_string
      t.rename :street_address, :address
      t.remove :postcode_id
    end

    add_reference :properties, :location, foreign_key: true

    change_table :recommendations do |t|
      t.remove :postcode
      t.remove :postcode_id
    end

    add_reference :recommendations, :location, foreign_key: true


  end
end
