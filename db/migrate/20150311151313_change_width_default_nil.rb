class ChangeWidthDefaultNil < ActiveRecord::Migration[4.2]
  def change
    change_column_null :photos, :width, true
    change_column_null :photos, :height, true
    remove_index :photos, :width
  end
end
