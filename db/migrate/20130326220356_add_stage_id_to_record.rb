class AddStageIdToRecord < ActiveRecord::Migration
  def change
    add_column :records, :stage_id, :integer
  end
end
