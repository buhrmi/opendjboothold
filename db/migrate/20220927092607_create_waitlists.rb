class CreateWaitlists < ActiveRecord::Migration[7.0]
  def change
    create_table :waitlists do |t|
      t.integer :user_id
      t.integer :booth_id
      t.integer :position

      t.index :booth_id
      t.index :user_id

      t.timestamps
      t.index :created_at
    end
  end
end
