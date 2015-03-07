class AddActorIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :actor_id, :integer, after: :post_id
    add_index :photos, :actor_id
  end
end
