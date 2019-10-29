# frozen_string_literal: true

# Chats class used to create the chats worker for the chats creation endpoint
class ChatsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 3

  def perform(apptoken, name, lastid)
    # Get the application by token
    @app = Application.find_by(token: apptoken)

    # Create the chat using ActiveRecord_Relation
    if @chat = @app.chats.create(name: name, token: lastid)
      store message: 'Chat has been created successfully'
    else
      store message: 'Could not save the chat. Please try again later'
    end
    retrieve :message
  end
end
