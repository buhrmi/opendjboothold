class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :provider_id
      t.json :provider_info
      t.integer :user_id

      t.timestamps

      t.index [:provider, :provider_id], unique: true
      t.index :user_id
    end
  end
end
