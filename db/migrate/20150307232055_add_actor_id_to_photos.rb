class AddActorIdToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :actor_id, :integer, after: :post_id
    add_index :photos, :actor_id
  end
end
