class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.string :postcode
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.references :postcode, null: false, foreign_key: true

      t.timestamps
    end
  end
end
