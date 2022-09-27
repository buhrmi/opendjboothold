class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  
  has_many :identities, dependent: :destroy

  has_many :waitlists, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true

  def transmission(receiver = nil)
    {
      id: id,
      name: name,
      display_name: display_name,
      email: receiver == self && email,
      avatar: avatar.signed_id
    }
  end

  def track
    # TODO: get first track from active playlist
    Track.where('duration < 60').sample
  end

end
