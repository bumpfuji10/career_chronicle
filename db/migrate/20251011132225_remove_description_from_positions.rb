class RemoveDescriptionFromPositions < ActiveRecord::Migration[7.1]
  def change
    remove_column :positions, :description, :text
  end
end
