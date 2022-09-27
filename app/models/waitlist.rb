class Waitlist < ApplicationRecord
  belongs_to :user
  belongs_to :booth

  default_scope { order(position: :asc).order(updated_at: :asc) }

  validates :user_id, uniqueness: { scope: :booth_id }

  after_create_commit do
    BoothChannel.broadcast_to(booth, action: 'update', changes: { waitlists: booth.waitlists.map(&:transmission) })
  end

  after_destroy_commit do
    BoothChannel.broadcast_to(booth, action: 'update', changes: { waitlists: booth.reload.waitlists.map(&:transmission) })
  end


  def transmission
    {
      id: id,
      user: user.transmission
    }
  end
end
