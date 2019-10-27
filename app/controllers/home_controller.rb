class HomeController < ApplicationController
    def index
        #Might be useful to create a json object with all required information. Such as status.endpoints for the available endpoints
        msg = { Status: "This is the main page of the API. More instructions will be added shortly!" }

        render json: msg
    end
end
