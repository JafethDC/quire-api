class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.belongs_to :seller, references: :user, index: true

      t.timestamps
    end
  end
end
