class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer  :original_post_id, limit: 8, null: false
      t.integer  :post_id,                    null: false
      t.integer  :width,                      null: false
      t.integer  :height,                     null: false
      t.string   :url,                        null: false
    end
    add_index :photos, :post_id
    add_index :photos, :url
    add_index :photos, :width
  end
end
