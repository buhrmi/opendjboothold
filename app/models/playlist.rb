class Playlist < ApplicationRecord
  belongs_to :user
  
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  
  validates :name, presence: true
  
  after_commit do
    user.push_update playlists: user.playlists.as_json
    push_update
  end

  def push_update
    user.push_update_into self, with_tracks
  end

  def with_tracks
    {
      id: id,
      name: name,
      tracks: tracks.as_json
    }
  end

  def store_id
    to_global_id.to_s
  end

end
