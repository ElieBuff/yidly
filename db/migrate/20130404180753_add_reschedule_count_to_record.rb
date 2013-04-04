class AddRescheduleCountToRecord < ActiveRecord::Migration
  def change
    add_column :records, :reschedule_count, :integer
  end
end
