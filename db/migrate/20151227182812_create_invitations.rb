class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.string :code

      t.timestamps null: false
    end
    add_foreign_key :invitations, :users
    add_foreign_key :invitations, :groups
  end
end
