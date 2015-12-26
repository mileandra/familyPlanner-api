class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :groups, :users, column: :owner_id
  end
end
