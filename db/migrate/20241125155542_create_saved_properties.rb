class CreateSavedProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_properties do |t|
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
