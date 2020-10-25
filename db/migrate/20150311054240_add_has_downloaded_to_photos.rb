class AddHasDownloadedToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :has_downloaded, :boolean, null: false, default: false, after: :average_hash
  end
end
