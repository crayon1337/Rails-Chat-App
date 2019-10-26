class ChatsController < ApplicationController
    def create
        #Error Handling region
        begin
            #Get the application by token
            @app = Application.where(:token => params[:application_token]).first
            
            #Create the chat using ActiveRecord_Relation
            if @chat = @app.chats.create(chat_params)

                #Increment chat_count
                @app.increment(:chats_count)

                #Save the app
                @app.save

                #Set the response Msg
                msg = { Status: "Chat has been assigned to application with token (#{params[:application_token]})", MsgsCount: @app[:chats_count], ChatNumber: @chat[:id] }
            else
                msg = {Status: "Could not add chat to application with token (#{params[:application_token]})"}
            end

        rescue => ex
            msg = ex
        end

        #Respond to the client
        render json: msg
    end

    private
        def chat_params
            params.permit(:name)
        end
end
