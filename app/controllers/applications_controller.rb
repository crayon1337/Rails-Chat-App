# frozen_string_literal: true

# Application Controller used to create the CRUD functionalities of /applications
class ApplicationsController < ApplicationController
  before_action :load_entity, only: %i[update destroy show]

  def create
    # Call set_application_token to generate the unique TOKEN for each application!
    token = set_application_token 20

    # Create a new database entry. TODO: use Database queue system
    @newapp = Application.new(app_params)

    # Update the token for the newely created application
    @newapp.token = token

    # If the creation is successful. Return a message alongside the token!
    if @newapp.save
      msg = { msg: 'Application has been created.', token: token }
      status = 200
    else
      msg = { msg: 'Could not create an application. Make sure you entered a name correctly!' }
      status = 422
    end

    # Render json response!
    render json: msg, status: status
  end

  def show
    # Render the return @app as JSON object
    render json: @app
  end

  def update
    # Set the name
    @app.name = params[:name]

    # Set the response value based on @app.update return
    if @app.save
      msg = { Status: 'Success', Message: 'Application name has been changed', ApplicationToken: @app.token }
      status = 200
    else
      msg = { Status: 'Failled', ApplicationToken: @app.token }
      status = 422
    end

    # Render json response
    render json: msg, status: status
  end

  def destroy
    # Destroy the app
    @app.destroy

    if @app.destroyed?
      # Set the successful response
      msg = { Status: 'Success', Message: 'Application has been deleted!', ApplicationToken: @app.token }
      status = 200
    else
      msg = { Message: 'Could not delete the application' }
      status = 422
    end

    # Return response to client
    render json: msg, status: status
  end

  private

  def set_application_token(length)
    # Keep generating until we're quite sure it's unique!
    loop do
      token = SecureRandom.hex length
      break token unless Application.where(token: token).exists?
    end
  end

  def app_params
    # Make sure the :name param is set!
    params.permit(:name)
  end

  protected

  def load_entity
    # Get the app by token
    @app = Application.find_by(token: params[:token])
  end
end
