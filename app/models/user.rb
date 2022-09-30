class User < ApplicationRecord
  include ActionStore

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
      playlists: receiver == self && playlists.map(&:pushable_data),
      email: receiver == self && email,
      avatar: avatar.signed_id
    }
  end

  def subscribed channel
    channel.push pushable_data(self)
    playlists.each do |playlist|
      playlist.push_to channel
    end
  end

  def store_id
    "user"
  end

  
  # ActionStore actions
  def perform_create_playlist user, name
    playlists.create!(name: name)
  end

  def perform_delete_playlist user, id
    playlists.find(id).destroy
  end

  def perform_add_to_active_playlist user, id
    active_playlist.tracks << Track.find(id)
  end

  def perform_set_active_playlist user, id
    update! active_playlist: playlists.find_by(id: id)
  end

  def perform_remove_from_playlist user, playlist_id, track_id
    playlists.find(playlist_id).playlist_tracks.where(track_id: track_id).destroy_all
  end

  def perform_move_track_to_top user, playlist_id, track_id
    playlists.find(playlist_id).playlist_tracks.where(track_id: track_id).first.move_to_top
  end

end
