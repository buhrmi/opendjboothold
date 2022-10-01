module ActionStore
  extend ActiveSupport::Concern

  def push_update changes
    push_update_into nil, changes
  end

  def serialized_changes
    saved_changes.transform_values(&:last)
  end

  def push_update_into store_id, changes = {}
    StoresChannel.broadcast_to self, store_id: ActionStore.store_id(store_id), action: 'update', changes: changes
  end

  def self.store_id subject
    if subject.nil?
      nil
    elsif subject.is_a? String
      subject
    elsif subject.respond_to? :to_store_id
      subject.to_store_id
    else
      ActionView::RecordIdentifier.dom_id subject
    end
  end
end