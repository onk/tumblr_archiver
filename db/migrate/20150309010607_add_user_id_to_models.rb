class AddUserIdToModels < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :user_id, :integer, null: false, after: :id
    remove_index :photos, :actor_id
    add_index :photos, [:user_id, :actor_id]
    remove_index :photos, :url
    add_index :photos, [:user_id, :url]

    add_column :posts, :user_id, :integer, null: false, after: :id
    remove_index :posts, :original_id
    add_index :posts, [:user_id, :original_id], unique: true
    remove_index :posts, :posted_at
    add_index :posts, [:user_id, :posted_at]
    remove_index :posts, :url
    add_index :posts, [:user_id, :url]
  end
end
