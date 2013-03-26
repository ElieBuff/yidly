class AddActionToStage < ActiveRecord::Migration
  def change
    add_column :stages, :action, :string
  end
end
