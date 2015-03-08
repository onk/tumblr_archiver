class AddAverageHashToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :average_hash, :string
  end
end
