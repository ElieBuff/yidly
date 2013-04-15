class AddIconToStage < ActiveRecord::Migration
  def change
    add_column :stages, :icon, :string
  end
end
