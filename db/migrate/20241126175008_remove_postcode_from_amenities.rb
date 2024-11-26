class RemovePostcodeFromAmenities < ActiveRecord::Migration[7.1]
  def change
    remove_reference :amenities, :postcode, null: false, foreign_key: true
  end
end
