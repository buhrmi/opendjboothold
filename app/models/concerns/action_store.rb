module ActionStore
  extend ActiveSupport::Concern
  
  def self.store_id subject
    if subject.respond_to? :store_id
      subject.store_id
    elsif subject.is_a? String
      subject
    else
      subject.to_global_id.to_s
    end
  end

  included do
    after_commit :push
  end

  def push changes = pushable_changes
    push_into self, changes
  end

  def pushable_changes
    previous_changes.map { |k, v| [k, v[1]] }.to_h if changes.empty?
  end

  def push_into store, changes = {}
    StoresChannel.broadcast_to self, store: ActionStore.store_id(store), action: 'update', changes: changes
  end
end