class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name,               null: false
      t.string :provider,           null: false
      t.string :provider_user_id,   null: false
      t.string :oauth_token,        null: false
      t.string :oauth_token_secret, null: false

      t.timestamps null: false
    end
    add_index :users, [:provider, :provider_user_id], unique: true
  end
end
