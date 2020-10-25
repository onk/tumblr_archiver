class AddImageToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :image, :string, after: :url
  end
end
