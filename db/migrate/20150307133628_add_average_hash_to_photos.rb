class AddAverageHashToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :average_hash, :string, after: :url
  end
end
