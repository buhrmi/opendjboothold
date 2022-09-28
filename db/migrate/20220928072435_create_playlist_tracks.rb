class CreatePlaylistTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_tracks do |t|
      t.integer :playlist_id
      t.integer :track_id
      t.integer :position

      t.timestamps

      t.index :playlist_id
      t.index :track_id
    end
  end
end
