class BoothChannel < ApplicationCable::Channel
  def subscribed
    @booth = Booth.find(params[:id])
    stream_for @booth
  end

  def join_waitlist
    waitlist = @booth.waitlists.create(user: current_user)
  end

  def leave_waitlist
    @booth.waitlists.where(user: current_user).destroy_all
  end

  def skip_track
    @booth.next!
  end

  def send_message
    broadcast_to @booth, action: 'message', message: params[:message]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
