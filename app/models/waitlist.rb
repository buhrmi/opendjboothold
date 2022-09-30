class Waitlist < ApplicationRecord
  belongs_to :user
  belongs_to :booth

  default_scope { order(position: :asc).order(updated_at: :asc) }

  validates :user_id, uniqueness: true

  after_commit -> { booth.push waitlists: booth.reload.waitlists.map(&:pushable_data) }
  

  def pushable_data
    {
      id: id,
      user: user.pushable_data
    }
  end
end
