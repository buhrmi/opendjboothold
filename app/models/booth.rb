class Booth < ApplicationRecord
  belongs_to :track, optional: true
  belongs_to :dj, class_name: "User", optional: true

  validates :name, presence: true

  after_update_commit :broadcast_update
  
  def broadcast_update
    BoothChannel.broadcast_to(self, self.for_transmission)
  end

  def for_transmission
    {
      id: id,
      name: name,
      start_time: start_time,
      track: track&.for_transmission
    }
  end

  def next!
    
    self.dj = User.first
    self.track = self.dj.track
    self.start_time = Time.now
    self.save
  end
  
end
