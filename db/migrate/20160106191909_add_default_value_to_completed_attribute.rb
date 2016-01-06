class AddDefaultValueToCompletedAttribute < ActiveRecord::Migration
  def up
    change_column :todos, :completed, :boolean, :default => false
  end

  def down
    change_column :todos, :completed, :boolean, :default => nil
  end
end
