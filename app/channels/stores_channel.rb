class StoresChannel < ApplicationCable::Channel
  def subscribed
    @subject = GlobalID::Locator.locate_signed params[:sgid]
    return reject unless @subject
    stream_for @subject
    @subject.subscribed self if @subject.respond_to? :subscribed
  end

  def push changes
    push_into ActionStore.store_id(@subject), changes
  end

  def push_into store, changes
    transmit({store: ActionStore.store_id(store), action: 'update', changes: changes})
  end
  
  def perform_action data
    @subject.send "perform_#{data['action']}", current_user, *data['args']
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
