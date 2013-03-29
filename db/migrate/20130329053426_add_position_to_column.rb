class AddPositionToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :position, :integer
  end
end
