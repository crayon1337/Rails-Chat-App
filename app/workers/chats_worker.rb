class ChatsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 3

  def perform(appToken, name, lastId)
    #Get the application by token
    @app = Application.where(:token => appToken).select(:id, :chats_count, :name).first

    #Create the chat using ActiveRecord_Relation
    if @chat = @app.chats.create(:name => name, :token => lastId)

      #Increment chat_count
      @app.increment(:chats_count)

      #Save the app
      @app.save
    else 
      store message: "Could not save the chat. Please try again later"
      vino = retrieve :message
    end
    
  end

end
