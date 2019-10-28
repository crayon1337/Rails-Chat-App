class MessagesController < ApplicationController
    def index 
        #Error handling
        begin
            #Get the application by token
            @app = Application.where(:token => params[:application_token]).first

            #Get the chat by chat_id
            @chat = @app.chats.where(:token => params[:chat_token]).first

            #Get messages of chat!
            @messages = @chat.messages.all

            #Render the response as an JSON object
            render json: @messages
        rescue => ex 
            render json: "Could not get the messages!"
        end
    end

    def create
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first
        
        #Get the chat by chat_id
        @chat = @app.chats.where(:token => params[:chat_token]).first

        #Get the last ID +1
        @MessageNumber = Message.where(:chat_id => @chat.id).pluck(Arel.sql('coalesce(max(token)+1, 1)')).first

        if params[:body] && params[:sender]
            #Start the worker
            job_id = MessagesWorker.perform_async params[:sender], params[:body], @MessageNumber, params[:application_token], params[:chat_token]

            #Set the successful return value
            returnValue = {Status: "Success", Message: "Your message is being processed by our server", MessageNumber: @MessageNumber, ChatNumber: params[:chat_token], ApplicationToken: params[:application_token], JobID: job_id}
        else
            #Set the failure return value
            returnValue = {Status: "Failed", Message: "Every message needs a body and a sender name."}
        end

        #Respond to the client
        render json: returnValue
    end

    def show 
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first

        #Get the chat by chat_id
        @chat = @app.chats.where(:token => params[:chat_token]).first

        #Get the message
        @message = @chat.messages.where(:token => params[:token]).first
        
        #Render the @message as JSON object
        render json: @message
    end

    def update 
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first

        #Get the chat by chat_id
        @chat = @app.chats.where(:token => params[:chat_token]).first

        #Get the message
        @message = @chat.messages.where(:token => params[:token]).first

        #Set the message body
        @message.body = params[:body]

        #Set the response based on @message.save
        if @message.save
            msg = {Status: "Success", Message: "Message body has been changed", MessageNumber: @message.token, "Application Token": @app.token}
        else
            msg = {Status: "Failled", MessageNumber: @message.token, "Application Token": @app.token}
        end

        render json: msg
    end

    def destroy 
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first

        #Get the chat by chat_id
        @chat = @app.chats.where(:token => params[:chat_token]).first

        #Get the message
        @message = @chat.messages.where(:token => params[:token]).first

        #Destroy the message
        @message.destroy

        #Decrement the messages_count
        @chat.decrement(:messages_count)

        #Save the chat
        @chat.save

        msg = { Status: "Success", "Message": "Message has been deleted!", "MessageNumber": @message.token, "Application Token": @app.token}

        render json: msg
    end

    private
        def message_params 
            params.permit(:sender, :body)
        end
end
