class MessagesWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  
  sidekiq_options retry: 3

  def perform(sender, body, messageNumber, appToken, chatToken)
    #Get the application by token
    @app = Application.find_by(:token => appToken)

    #Get the chat by chat_id
    @chat = @app.chats.find_by(:token => chatToken)

    #Create the message based on chat relationship
    if @message = @chat.messages.create(:sender => sender, :body => body, :token => messageNumber)
      store message: "Message has been created successfully"
    else
      store message: "Could not save the message. Please try again later"
    end
    vino = retrieve :message
  end
end
