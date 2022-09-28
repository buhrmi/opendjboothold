class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :plays, dependent: :destroy

  def transmission
    {
      id: id,
      title: title,
      service: service,
      service_id: service_id,
      uploader: uploader,
      thumbnail: thumbnail,
      duration: duration
    }
  end
end
