class ChangeEndedAtToNullableInCompaniesAndPositions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :companies, :ended_at, true
    change_column_null :positions, :ended_at, true
  end
end
