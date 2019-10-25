class ApplicationsController < ApplicationController
    def index
        msg = { foo: "bar" }

        render json: msg
    end

    def create 
        #Error handling
        begin
            #Call set_application_token to generate the unique TOKEN for each application!
            token = set_application_token 20

            @app = Application.new(getInputs)

            @app.token = token

            if @app.save
                msg = {msg: "Application has been created.", token: token}
            else
                msg = {msg: "Could not create an application. Make sure you entered a name correctly!"}
            end

            render json: msg
        rescue => ex 
            render json: ex
        end
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
            params.permit(:name)
        end
end
