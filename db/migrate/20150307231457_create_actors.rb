class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
