class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    transmit current_user.json_for_transmit
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
