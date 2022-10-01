class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :plays, dependent: :destroy
end
