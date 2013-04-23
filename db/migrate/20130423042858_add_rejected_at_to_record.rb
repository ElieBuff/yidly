class AddRejectedAtToRecord < ActiveRecord::Migration
  def change
    add_column :records, :rejected_at, :datetime
  end
end
