class AddProjectIdToRecords < ActiveRecord::Migration
  def change
    add_column :records, :project_id, :integer
  end
end
