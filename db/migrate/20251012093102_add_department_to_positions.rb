class AddDepartmentToPositions < ActiveRecord::Migration[7.1]
  def change
    add_column :positions, :department, :string, null: false
  end
end
