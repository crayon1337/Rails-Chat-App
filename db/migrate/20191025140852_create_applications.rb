class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.uuid :token, unique: true
      t.integer :chats_count, :default => 0

      t.timestamps
    end
  end
end
