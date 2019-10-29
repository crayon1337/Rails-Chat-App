# frozen_string_literal: true

# MessagesWorker class used to create the messages worker for messages creation endpoint
class MessagesWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 3

  def perform(sender, body, messagenumber, apptoken, chattoken)
    # Get the application by token
    @app = Application.find_by(token: apptoken)

    # Get the chat by chat_id
    @chat = @app.chats.find_by(token: chattoken)

    # Create the message based on chat relationship
    if @message == @chat.messages
                        .create(sender: sender, body: body, token: messagenumber)
      store message: 'Message has been created successfully'
    else
      store message: 'Could not save the message. Please try again later'
    end
    retrieve :message
  end
end
