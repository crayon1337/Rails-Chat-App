class ChatsController < ApplicationController
    def index 
        #Error handling region
        begin
            #Get the app by token
            @app = Application.where(:token => params[:application_token]).first 

            #Get all chats of that app
            @chats = @app.chats.all

            #Return the response as JSON object
            render json: @chats
        rescue => ex 
            render json: "Could not get the chats!"
        end
    end

    def create
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).select(:id, :chats_count).first

        loop do
            #Get the last ID +1
            @ChatNumber = Chat.where(:application_id => @app.id).pluck(Arel.sql('coalesce(max(token)+1, 1)')).first
            break @ChatNumber unless Chat.where(:token => @ChatNumber, :application_id => @app.id).exists?
        end

        if params[:name]
            #Run the worker!
            job_id = ChatsWorker.perform_async(params[:application_token], params[:name], @ChatNumber)
            #Set successful return value
            returnValue = {Status: "Success", Message: "Your chat is being created by our server.", ChatNumber: @ChatNumber, ApplicationToken: params[:application_token], JobID: job_id}
        else
            #Set failure return value
            returnValue = {Status: "Failed", Message: "Every chat needs a name, right?"}
        end

        # #Respond to the client
        render json: returnValue
    end

    def show 
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first 

        #Get the chat
        @chat = @app.chats.where(:token => params[:token]).first

        #Render @chat as JSON object 
        render json: @chat
    end

    def update
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first 

        #Get the chat
        @chat = @app.chats.where(:token => params[:token]).first

        #Set the name
        @chat.name = params[:name]

        #Set the response based on @chat.save
        if @chat.save
            msg = {Status: "Success", Message: "Chat name has been changed", ChatNumber: @chat.token, "Application Token": @app.token}
        else
            msg = {Status: "Failled", ChatNumber: @chat.token, "Application Token": @app.token}
        end

        render json: msg
    end

    def destroy 
        #Get the app by token
        @app = Application.where(:token => params[:application_token]).first 

        #Get the chat by number
        @chat = @app.chats.where(:token => params[:token]).first
        
        #Destroy the chat 
        @chat.destroy

        #Reduce the application chats_count
        @app.decrement(:chats_count)

        #Save the app
        @app.save

        msg = { Status: "Success", "Message": "Chat has been deleted!", "ChatNumber": @chat.token, "Application Token": @app.token}

        render json: msg
    end
end
