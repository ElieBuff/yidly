class AddHiringManagerToProject < ActiveRecord::Migration
  def change
    add_column :projects, :hiring_manager, :string
  end
end
