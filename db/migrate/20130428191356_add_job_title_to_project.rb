class AddJobTitleToProject < ActiveRecord::Migration
  def change
    add_column :projects, :job_title, :string
  end
end
