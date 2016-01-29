class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.boolean :completed
      t.references :user, index: true
      t.references :group, index: true
      t.references :creator, index: true

      t.timestamps null: false
    end
    add_foreign_key :todos, :users
    add_foreign_key :todos, :groups
    add_foreign_key :todos, :users
  end
end
