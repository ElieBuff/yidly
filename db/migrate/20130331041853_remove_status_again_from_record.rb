class RemoveStatusAgainFromRecord < ActiveRecord::Migration
  def up
    remove_column :records, :status
  end

  def down
    add_column :records, :status, :string
  end
end
