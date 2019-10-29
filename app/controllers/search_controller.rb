class SearchController < ApplicationController
    def doFullMagic
        #Find app by it's token
        @app = Application.find_by(:token => params[:application_token])

        #Find chat by it's number
        @chat = @app.chats.find_by(:token => params[:chat_token])

        #Only do the search if the chat exists
        if !@chat.nil?
            #Search over messages
            @returnValue = @chat.messages.search(params[:q])
            status = 200
        else
            @returnValue = {Message: "Could not find chat with number #{params[:chat_token]}"}
            status = 404
        end

        #Return as JSON object
        render json: @returnValue, :status => status
    end
end
