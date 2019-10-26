class ChatsController < ApplicationController
    def create
        #Get the application by token
        @app = Application.where(:token => params[:application_token]).first
        
        #Create the chat using ActiveRecord_Relation
        if @app.chats.create(chat_params)

        #Increment chat_count
        @app.increment(:chats_count)

        #Save the app
        @app.save

        else
            msg = {Status: "Could not add chat to application with token (#{params[:application_token]})"}
        end

        #Set the response Msg
        msg = { Status: "Chat has been assigned to application with token (#{params[:application_token]})", MsgsCount: @app[:chats_count] }

        #Respond to the client
        render json: msg
    end

    private
        def chat_params
            params.permit(:name)
        end
end
