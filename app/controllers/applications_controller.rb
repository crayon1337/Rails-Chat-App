class ApplicationsController < ApplicationController
    def index
        #Might be useful to create a json object with all required information. Such as status.endpoints for the available endpoints
        msg = { Status: "This is the main page of the API. More instructions will be added shortly!" }

        render json: msg
    end

    def create 
        #Begin Error handling block
        begin
            #Call set_application_token to generate the unique TOKEN for each application!
            token = set_application_token 20

            #Create a new database entry. TODO: use Database queue system
            @app = Application.new(getInputs)

            #Update the token for the newely created application
            @app.token = token

            #If the creation is successful. Return a message alongside the token!
            if @app.save
                msg = {msg: "Application has been created.", token: token}
            else
                msg = {msg: "Could not create an application. Make sure you entered a name correctly!"}
            end

            #Render json response!
            render json: msg
        #Print the exception to the client for now.
        rescue => ex 
            render json: ex
        end
    end

    def destroy 
        #Get the app by token
        @app = Application.where(:token => params[:token]).first

        #Destroy the app
        @app.destroy

        #Set the response 
        msg = { Status: "Success", "Message": "Application has been deleted!", "Application Token": @app.token}

        #Return response to client
        render json: msg

    end

    private
        def set_application_token(length)
            #Keep generating until we're quite sure it's unique!
            loop do 
                token = SecureRandom.hex length
                break token unless Application.where(token: token).exists?
            end
        end

        def getInputs
            #Make sure the :name param is set!
            params.permit(:name)
        end
end
