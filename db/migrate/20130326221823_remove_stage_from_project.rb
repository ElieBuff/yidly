class RemoveStageFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :stage_id
  end

  def down
    add_column :projects, :stage_id, :string
  end
end
