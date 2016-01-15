class AddSubjectAndResponseToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
    add_reference :messages, :responds
    add_foreign_key :messages, :responds
  end
end
