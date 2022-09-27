class Booth < ApplicationRecord
  belongs_to :track, optional: true
  belongs_to :dj, class_name: "User", optional: true

  has_many :waitlists, dependent: :destroy

  validates :name, presence: true

  after_update_commit :broadcast_update
  
  def remaining
    if track
      track.duration - elapsed
    else
      0
    end
  end

  def elapsed
    Time.now - start_time
  end

  def broadcast_update
    BoothChannel.broadcast_to(self, action: 'update', changes: previous_changes.map { |k, v| [k, v[1]] }.to_h)
    if previous_changes[:track_id]
      BoothChannel.broadcast_to(self, action: 'new_track',  track: track&.transmission )
    end
  end

  def transmission
    {
      id: id,
      name: name,
      elapsed: elapsed.to_i,
      track: track&.transmission,
      dj: dj&.transmission,
      waitlists: waitlists.map(&:transmission)
    }
  end

  def next!
    next_list = waitlists.first
    if next_list
      self.dj = next_list.user
      self.track = self.dj.track
      self.start_time = Time.now
      self.save
      next_list.touch
    else
      self.dj = nil
      self.track = nil
      self.start_time = nil
      self.save
    end
  end
  
end
