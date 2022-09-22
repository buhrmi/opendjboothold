require 'open-uri'

class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :provider_id, presence: true, uniqueness: { scope: :provider }

  def self.from_omniauth! auth_hash
    identity = Identity.find_or_create_by(provider: auth_hash['provider'], provider_id: auth_hash['uid']) do |identity|
      identity.user ||= User.new(email: auth_hash['info']['email'], password: SecureRandom.hex, display_name: auth_hash['info']['name'], name: auth_hash['info']['nickname'])
      if auth_hash['provider'] == 'twitter'
        image = URI.parse(auth_hash['info']['image']).open
        identity.user.avatar.attach(io: image, filename: 'avatar.jpg')
      end
    end
  end
end