class Message < ApplicationRecord
    #Each message belongs to a chat
    belongs_to :chat

    #Validate the sender & body
    validates :sender, presence: true, length: {minimum: 3}
    validates :body, presence: true, length: {minimum: 3}
end
