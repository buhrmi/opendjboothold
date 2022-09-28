class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.integer :position, default: 0
      t.string :name

      t.timestamps

      t.index :user_id
    end
  end
end
