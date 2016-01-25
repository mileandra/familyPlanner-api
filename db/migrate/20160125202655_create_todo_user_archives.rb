class CreateTodoUserArchives < ActiveRecord::Migration
  def change
    create_table :todo_user_archives do |t|
      t.references :user, index: true
      t.references :todo, index: true
      t.boolean :archived

      t.timestamps null: false
    end
    add_foreign_key :todo_user_archives, :users
    add_foreign_key :todo_user_archives, :todos
  end
end
