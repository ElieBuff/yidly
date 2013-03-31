class RemoveProjectFromRecord < ActiveRecord::Migration
  def up
    remove_column :records, :project_id
  end

  def down
    add_column :records, :project_id, :string
  end
end
