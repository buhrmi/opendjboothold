class CreateBooths < ActiveRecord::Migration[7.0]
  def change
    create_table :booths do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end
    add_index :booths, :owner_id
  end
end
