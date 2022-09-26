class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :uploader
      t.integer :duration
      t.string :service
      t.string :service_id
      t.string :thumbnail

      t.index [:service, :service_id], unique: true

      t.timestamps
    end
  end
end
