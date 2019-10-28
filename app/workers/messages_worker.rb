class MessagesWorker
  include Sidekiq::Worker

  def perform(sender, body, messageNumber, appToken, chatToken)
    #Get the application by token
    @app = Application.where(:token => appToken).first

    #Get the chat by chat_id
    @chat = @app.chats.where(:token => chatToken).first

    #Create the message based on chat relationship
    if @message = @chat.messages.create(:sender => sender, :body => body, :token => messageNumber)

      #increase messages count
      @chat.increment(:messages_count)

      #Save the chat
      @chat.save

    else
      store message: "Could not save the message. Please try again later"
      vino = retrieve :message
    end

  end

end
