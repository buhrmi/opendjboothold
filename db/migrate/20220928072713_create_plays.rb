class CreatePlays < ActiveRecord::Migration[7.0]
  def change
    create_table :plays do |t|
      t.integer :track_id
      t.integer :booth_id
      t.integer :user_id
      t.integer :woots_count
      t.integer :grabs_count
      t.integer :mehs_count

      t.timestamps

      t.index :track_id
      t.index :booth_id
      t.index :user_id
    end
  end
end
