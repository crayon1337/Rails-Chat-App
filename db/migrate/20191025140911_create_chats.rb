# frozen_string_literal: true

# CreateChats class used to create the table chats
class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.string :name
      t.integer :token
      t.integer :messages_count, default: 0
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
