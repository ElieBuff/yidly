class AddStageToProject < ActiveRecord::Migration
  def change
    add_column :projects, :stage_id, :integer
  end
end
