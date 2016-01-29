class AddSubjectAndResponseToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
    add_reference :messages, :responds
    add_foreign_key :messages, :messages, column: :responds_id
  end
end
