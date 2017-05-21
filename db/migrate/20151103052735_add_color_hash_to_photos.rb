class AddColorHashToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :color_hash, :string, after: :average_hash
  end
end
