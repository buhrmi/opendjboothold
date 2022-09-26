class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  
  has_many :identities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :email, presence: true, uniqueness: true

  def json_for_transmit
    {
      id: id,
      name: name,
      display_name: display_name,
      email: email,
      avatar: avatar.signed_id
    }
  end

  def track
    # TODO: get first track from active playlist
    Track.all.sample
  end

end
