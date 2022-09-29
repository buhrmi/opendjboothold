class PlaylistTrack < ApplicationRecord
  acts_as_list scope: :playlist

  belongs_to :playlist
  belongs_to :track

  default_scope { order(position: :asc) }

  after_commit -> { playlist.broadcast }

  delegate :as_prop, to: :track
  delegate :duration, to: :track
end
