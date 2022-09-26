class AddTrackIdAndDjIdToBooths < ActiveRecord::Migration[7.0]
  def change
    add_column :booths, :track_id, :integer
    add_column :booths, :dj_id, :integer
    add_column :booths, :start_time, :timestamp

    add_index :booths, :track_id
    add_index :booths, :dj_id
  end
end
