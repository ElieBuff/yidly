class AddCompanyIconToProject < ActiveRecord::Migration
  def change
    add_column :projects, :company_icon, :string
  end
end
