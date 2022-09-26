class BoothChannel < ApplicationCable::Channel
  def subscribed
    booth = Booth.find(params[:id])
    stream_for booth
    transmit booth.for_transmission
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
