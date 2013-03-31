class AddActionableAtToRecord < ActiveRecord::Migration
  def change
    add_column :records, :actionable_at, :date
  end
end
