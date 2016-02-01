class AddAuthorToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :author, :string
  end
end
