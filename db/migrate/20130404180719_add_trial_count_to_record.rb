class AddTrialCountToRecord < ActiveRecord::Migration
  def change
    add_column :records, :trial_count, :integer
  end
end
