class Booth < ApplicationRecord
  has_actionstore

  belongs_to :track, class_name: 'PlaylistTrack', optional: true
  belongs_to :dj, class_name: "User", optional: true

  has_many :waitlists, dependent: :destroy

  validates :name, presence: true
  
  after_commit do
    push_update serialized_changes
  end

  def remaining
    if track
      track.duration - elapsed
    else
      0
    end
  end

  def elapsed
    start_time && Time.now - start_time || 0
  end

  def track_finished?
    !track || elapsed >= track.duration
  end


  def pushable_data
    {
      id: id,
      gid: to_global_id.to_s,
      sgid: to_sgid.to_s,
      name: name,
      elapsed: elapsed.to_i,
      track: track&.as_json,
      dj: dj&.pushable_data,
      waitlists: waitlists.map(&:pushable_data)
    }
  end

  def serialized_changes
    changes = super
    changes[:dj] = dj&.pushable_data if previous_changes[:dj_id]
    changes[:track] = track&.as_json if previous_changes[:track_id]
    changes
  end

  def next!
    reload
    next_list = waitlists.first
   
    if next_list
      self.dj = next_list.user
      self.track = self.dj.track
      self.track&.move_to_bottom
      self.start_time = Time.now
      self.save
      next_list.touch # this will update "updated_at" and move it to the end of the list
    else
      self.dj = nil
      self.track = nil
      self.start_time = nil
      self.save
    end
  end
  

  # ActionStore methods

  def perform_join_waitlist user
    waitlist = waitlists.create(user: user)
  end

  def perform_leave_waitlist user
    waitlists.where(user: user).destroy_all
  end

  def perform_skip_track user
    next!
  end

end
