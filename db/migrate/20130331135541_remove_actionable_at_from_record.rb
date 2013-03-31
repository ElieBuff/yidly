class RemoveActionableAtFromRecord < ActiveRecord::Migration
  def up
    remove_column :records, :actionable_at
  end

  def down
    add_column :records, :actionable_at, :string
  end
end
