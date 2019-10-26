class SearchController < ApplicationController
    def doFullMagic
        #Search over messages
        @messages = Message.search params[:q]

        #Return as JSON object
        render json: @messages
    end
end
