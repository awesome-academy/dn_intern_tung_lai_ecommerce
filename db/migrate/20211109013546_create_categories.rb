class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.bigint :parent_id
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
