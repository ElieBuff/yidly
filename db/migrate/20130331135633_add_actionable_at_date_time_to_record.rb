class AddActionableAtDateTimeToRecord < ActiveRecord::Migration
  def change
    add_column :records, :actionable_at, :datetime
  end
end
