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
        #Error Handling region
        begin
            #Get the application by token
            @app = Application.where(:token => params[:application_token]).first

            #Get the last ID +1
            @lastId = Chat.where(:application_id => @app.id).pluck('coalesce(max(token)+1, 1)').first
            
            #Create the chat using ActiveRecord_Relation
            if @chat = @app.chats.create(chat_params)

                #Increment chat_count
                @app.increment(:chats_count)

                #Save the app
                @app.save

                #Set the fake identifier
                @chat.token = @lastId

                #Save the chat after update!
                @chat.save

                #Set the response Msg
                msg = { Status: "Chat has been assigned to application with token (#{params[:application_token]})", MsgsCount: @chat[:messages_count], ChatNumber: @chat[:token] }
            else
                msg = {Status: "Could not add chat to application with token (#{params[:application_token]})"}
            end

        rescue => ex
            msg = ex
        end

        #Respond to the client
        render json: msg
    end

    def destroy 
        #Get the app by token
        @app = Application.where(:token => params[:application_token]).first 

        #Get the chat by number
        @chat = @app.chats.where(:token => params[:token]).first
        
        #Destroy the chat 
        @chat.destroy

        msg = { Status: "Success", "Message": "Chat has been deleted!", "ChatNumber": @chat.token, "Application Token": @app.token}

        render json: msg
    end

    private
        def chat_params
            params.permit(:name)
        end
end
