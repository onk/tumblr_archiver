class AddImageToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :image, :string, after: :url
  end
end
