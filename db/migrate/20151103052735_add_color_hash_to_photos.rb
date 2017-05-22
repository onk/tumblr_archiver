class AddColorHashToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :color_hash, :string, limit: 1023, after: :average_hash
  end
end
