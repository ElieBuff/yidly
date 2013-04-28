class AddJobDescriptionIconToProject < ActiveRecord::Migration
  def change
    add_column :projects, :job_description, :string
  end
end
