class Waitlist < ApplicationRecord
  belongs_to :user
  belongs_to :booth

  default_scope { order(position: :asc).order(updated_at: :asc) }

  validates :user_id, uniqueness: { scope: :booth_id }

  after_commit -> { booth.reload.broadcast_waitlists }
  

  def transmission
    {
      id: id,
      user: user.transmission
    }
  end
end
