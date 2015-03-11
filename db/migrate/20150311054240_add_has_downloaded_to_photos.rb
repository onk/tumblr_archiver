class AddHasDownloadedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :has_downloaded, :boolean, null: false, default: false, after: :average_hash
  end
end
