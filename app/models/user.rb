class User < ApplicationRecord
  has_actionstore

  has_secure_password
  has_one_attached :avatar

  belongs_to :active_playlist, class_name: 'Playlist', optional: true
  
  has_many :playlists, class_name: 'Playlist', dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :waitlists, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_create :create_default_playlist

  after_commit do
    push_update serialized_changes
  end

  def track
    active_playlist.playlist_tracks.first if active_playlist
  end

  def create_default_playlist
    self.active_playlist = playlists.new(name: 'My Playlist')
  end

  # ActionStore methods
  def pushable_data(receiver = nil)
    {
      id: id,
      name: name,
      display_name: display_name,
      active_playlist_id: active_playlist_id,
      playlists: receiver == self && playlists.as_json,
      email: receiver == self && email,
      avatar: avatar.signed_id
    }
  end

  def subscribed channel
    channel.push_update pushable_data(self)
    playlists.each do |playlist|
      channel.push_update_into playlist, playlist.with_tracks
    end
  end
  
  # ActionStore actions
  def perform_create_playlist channel, name
    playlists.create!(name: name)
  end

  def perform_delete_playlist channel, id
    playlists.find(id).destroy
  end

  def perform_add_to_active_playlist channel, id
    active_playlist.tracks << Track.find(id)
  end

  def perform_set_active_playlist channel, id
    update! active_playlist: playlists.find_by(id: id)
  end

  def perform_remove_from_playlist channel, playlist_id, track_id
    playlists.find(playlist_id).playlist_tracks.where(track_id: track_id).destroy_all
  end

  def perform_move_track_to_top channel, playlist_id, track_id
    playlists.find(playlist_id).playlist_tracks.where(track_id: track_id).first.move_to_top
  end

end
