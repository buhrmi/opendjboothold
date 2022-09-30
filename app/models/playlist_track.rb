class PlaylistTrack < ApplicationRecord
  acts_as_list scope: :playlist

  belongs_to :playlist
  belongs_to :track

  default_scope { order(position: :asc) }

  after_commit -> { playlist.push_to user }
    
  delegate :user, to: :playlist
  delegate :pushable_data, to: :track
  delegate :duration, to: :track
end
