class RemoveDescriptionFromCompanies < ActiveRecord::Migration[7.1]
  def change
    remove_column :companies, :description, :text
  end
end
