class CreatePosts < ActiveRecord::Migration[4.2]
  def change
    create_table :posts do |t|
      t.integer  :original_id, limit: 8, null: false
      t.string   :url,                   null: false
      t.datetime :posted_at,             null: false
      t.integer  :photo_count,           null: false, default: 1
      t.timestamps null: false
    end
    add_index :posts, :original_id, unique: true
    add_index :posts, :url
    add_index :posts, :posted_at
  end
end
