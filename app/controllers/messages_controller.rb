class MessagesController < ApplicationController
    def create
        #Error handling region
        begin
            #Get the application by token
            @app = Application.where(:token => params[:application_token]).first
            
            #Get the chat by chat_id
            @chat = @app.chats.where(:token => params[:chat_token]).first

            #Get the last ID +1
            @lastId = Message.where(:chat_id => @chat.id).pluck('coalesce(max(token)+1, 1)').first

            #Create the message based on chat relationship
            if @message = @chat.messages.create(message_params)

                #increase messages count
                @chat.increment(:messages_count)

                #Save the chat
                @chat.save

                #Set the fake identifier
                @message.token = @lastId

                #Save the chat after update!
                @message.save

                #Set the response value 
                msg = { Status: "Message has been added to chat (#{@chat[:token]})", MsgNumber: @message[:token], ApplicationToken: @app[:token] }
            
            else
                #Report we could not add a message
                msg = {Status: "Could not add a message to chat (#{@chat[:id]})"}

            end
        rescue => ex 
            msg = ex
        end

        #Respond to the client
        render json: msg

    end

    private
        def message_params 
            params.permit(:sender, :body)
        end
end
