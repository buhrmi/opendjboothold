class User < ApplicationRecord
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
  after_commit :broadcast

  def as_prop(receiver = nil)
    {
      id: id,
      name: name,
      display_name: display_name,
      active_playlist_id: active_playlist_id,
      playlists: receiver == self && playlists,
      email: receiver == self && email,
      avatar: avatar.signed_id
    }
  end

  def broadcast
    UserChannel.broadcast_to self, store: 'user', changes: as_prop(self)
  end

  def track
    active_playlist.playlist_tracks.first if active_playlist
  end

  def create_default_playlist
    self.active_playlist = playlists.new(name: 'My Playlist')
  end

end
