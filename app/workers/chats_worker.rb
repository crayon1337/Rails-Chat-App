class ChatsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 3

  def perform(appToken, name, lastId)
    #Get the application by token
    @app = Application.where(:token => appToken).select(:id, :chats_count, :name).first

    #Create the chat using ActiveRecord_Relation
    if @chat = @app.chats.create(:name => name, :token => lastId)
      store message: "Chat has been created successfully"
    else 
      store message: "Could not save the chat. Please try again later"
    end
    vino = retrieve :message
  end
end
