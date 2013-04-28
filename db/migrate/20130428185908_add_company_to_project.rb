class AddCompanyToProject < ActiveRecord::Migration
  def change
    add_column :projects, :company, :string
  end
end
