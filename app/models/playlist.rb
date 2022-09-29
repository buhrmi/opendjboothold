class Playlist < ApplicationRecord
  
  belongs_to :user
  
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  
  validates :name, presence: true

  # TODO: split into broadcast_add, broadcast_remove, broadcast_update
  after_commit :broadcast

  after_create_commit -> { UserChannel.broadcast_to user, store: 'user', changes: {playlists: user.playlists}}
  after_update_commit -> { UserChannel.broadcast_to user, store: 'user', changes: {playlists: user.playlists}}
  after_destroy_commit -> { UserChannel.broadcast_to user, store: 'user', changes: {playlists: user.playlists}}

  def broadcast
    UserChannel.broadcast_to user, store: "#{self.class.name.parameterize}_#{id}", changes: hash
  end

  def hash
    {
      id: id,
      name: name,
      tracks: tracks.map(&:hash)
    }
  end

end
