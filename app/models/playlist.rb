class Playlist < ApplicationRecord
  belongs_to :user
  
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  
  validates :name, presence: true
  
  after_commit do
    user.push playlists: user.playlists.map(&:pushable_data)
    push_to user
  end

  def push_to receiver
    receiver.push_into self, pushable_data_with_tracks
  end

  def store_id
    to_global_id.to_s
  end

  def pushable_data_with_tracks
    pushable_data.merge(tracks: tracks.map(&:pushable_data))
  end

  def pushable_data
    {
      id: id,
      name: name,
      store_id: store_id
    }
  end

end
