# frozen_string_literal: true

# CreateMessages class used to create the table messages
class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :sender
      t.text :body
      t.integer :token
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end
end
