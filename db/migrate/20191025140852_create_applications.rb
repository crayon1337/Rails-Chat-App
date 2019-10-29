# frozen_string_literal: true

# CreateCreateApplicationsChats class used to create the table applications
class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token, unique: true
      t.integer :chats_count, default: 0

      t.timestamps
    end
  end
end
