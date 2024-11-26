class AddColumnsToPostcode < ActiveRecord::Migration[7.1]
  def change
    add_column :postcodes, :demographic, :string
    add_column :postcodes, :constituency, :string
    add_column :postcodes, :afluence, :string
  end
end
