class ApplicationsController < ApplicationController
    before_action :load_entity
    
    def create 
        #Begin Error handling block
        begin
            #Call set_application_token to generate the unique TOKEN for each application!
            token = set_application_token 20

            #Create a new database entry. TODO: use Database queue system
            @newApp = Application.new(app_params)

            #Update the token for the newely created application
            @newApp.token = token

            #If the creation is successful. Return a message alongside the token!
            if @newApp.save
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

    def show 
        #Render the return @app as JSON object
        render json: @app
    end

    def update 
        #Set the name
        @app.name = params[:name]

        #Set the response value based on @app.update return
        if @app.save
            msg = {Status: "Success", Message: "Application name has been changed", "Application Token": @app.token}
        else
            msg = {Status: "Failled", "Application Token": @app.token}
        end

        #Render json response
        render json: msg

    end

    def destroy 
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

        def app_params
            #Make sure the :name param is set!
            params.permit(:name)
        end
    protected
        def load_entity
            #Get the app by token
            @app = Application.where(:token => params[:token]).first
        end
end
