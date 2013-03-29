class AddPositionToStage < ActiveRecord::Migration
  def change
    add_column :stages, :position, :integer
  end
end
