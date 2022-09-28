class AddActivePlaylistToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active_playlist_id, :integer
  end
end
