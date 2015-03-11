class ChangeWidthDefaultNil < ActiveRecord::Migration
  def change
    change_column_null :photos, :width, true
    change_column_null :photos, :height, true
    remove_index :photos, :width
  end
end
