class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    current_user.broadcast
    current_user.playlists.each(&:broadcast)
  end

  def create_playlist data
    current_user.playlists.create!(name: data['name'])
  end

  def delete_playlist data
    current_user.playlists.find(data['id']).destroy
  end

  def add_to_active_playlist data
    current_user.active_playlist.tracks << Track.find(data['id'])
  end

  def set_active_playlist data
    current_user.update!(active_playlist: current_user.playlists.find_by(id: data['id']))
  end

  def remove_from_playlist data
    current_user.playlists.find(data['playlist_id']).playlist_tracks.where(track_id: data['track_id']).destroy_all
  end

  def move_track_to_top data
    current_user.playlists.find(data['playlist_id']).playlist_tracks.where(track_id: data['track_id']).first.move_to_top
  end



  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
