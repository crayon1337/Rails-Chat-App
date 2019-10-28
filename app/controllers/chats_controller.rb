class ChatsController < ApplicationController
    before_action :load_entities

    def index 
        #Get all chats of that app
        @chats = @app.chats.all

        #Return the response as JSON object
        render json: @chats
    end

    def create
        #Get the last ID +1
        @ChatNumber = Chat.where(:application_id => @app.id).pluck(Arel.sql('coalesce(max(token)+1, 1)')).first

        if params[:name]
            #Run the worker!
            job_id = ChatsWorker.perform_async(params[:application_token], params[:name], @ChatNumber)
            #Set successful return value
            returnValue = {Status: "Success", Message: "Your chat is being created by our server.", ChatNumber: @ChatNumber, ApplicationToken: params[:application_token], JobID: job_id}
            
            status = 200
        else
            #Set failure return value
            returnValue = {Status: "Failed", Message: "Every chat needs a name, right?"}
            status = 422
        end

        # #Respond to the client
        render json: returnValue, :status => status
    end

    def show 
        #Render @chat as JSON object 
        render json: @chat
    end

    def update
        #Set the name
        @chat.name = params[:name]

        #Set the response based on @chat.save
        if @chat.save
            msg = {Status: "Success", Message: "Chat name has been changed", ChatNumber: @chat.token, "Application Token": @app.token}
            status = 200
        else
            msg = {Status: "Failled", ChatNumber: @chat.token, "Application Token": @app.token}
            status = 422
        end

        render json: msg, :status => status
    end

    def destroy 
        #Destroy the chat 
        @chat.destroy

        if @chat.destroyed?
            msg = { Status: "Success", "Message": "Chat has been deleted!", "ChatNumber": @chat.token, "Application Token": @app.token}
            status = 200
        else
            msg = {Message: "Could not delete this chat"}
            status = 422
        end

        render json: msg, :status => status
    end

    protected
        def load_entities
            #Get the application by token
            @app = Application.where(:token => params[:application_token]).first 
            #Get the chat
            @chat = @app.chats.where(:token => params[:token]).first
        end
end
