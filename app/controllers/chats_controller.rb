# frozen_string_literal: true

# Chats Controller used to create the CRUD functionalities of /applications/:token/chats
class ChatsController < ApplicationController
  before_action :load_entities

  def index
    # Get all chats of that app
    @chats = @app.chats.all

    # Return the response as JSON object
    render json: @chats
  end

  def create
    # Get the last ID +1
    @chatnumber = Chat.where(application_id: @app.id)
                      .pluck(Arel.sql('coalesce(max(token)+1, 1)')).first

    if params[:name]
      # Run the worker!
      job_id = ChatsWorker.perform_async(params[:application_token], params[:name], @chatnumber)
      # Set successful return value
      returnvalue = { Status: 'Success', Message: 'Your chat is being created by our server.', ChatNumber: @chatnumber, ApplicationToken: params[:application_token], JobID: job_id }

      status = 200
    else
      # Set failure return value
      returnvalue = { Status: 'Failed', Message: 'Every chat needs a name, right?' }
      status = 422
    end

    # Respond to the client
    render json: returnvalue, status: status
  end

  def show
    # Render @chat as JSON object
    render json: @chat
  end

  def update
    # Set the name
    @chat.name = params[:name]

    # Set the response based on @chat.save
    if @chat.save
      msg = { Status: 'Success', Message: 'Chat name has been changed', chatnumber: @chat.token, ApplicationToken: @app.token }
      status = 200
    else
      msg = { Status: 'Failled', chatnumber: @chat.token, ApplicationToken: @app.token }
      status = 422
    end

    render json: msg, status: status
  end

  def destroy
    # Destroy the chat
    @chat.destroy

    if @chat.destroyed?
      msg = { Status: 'Success', Message: 'Chat has been deleted!', chatnumber: @chat.token, ApplicationToken: @app.token }
      status = 200
    else
      msg = { Message: 'Could not delete this chat' }
      status = 422
    end

    render json: msg, status: status
  end

  protected

  def load_entities
    # Get the application by token
    @app = Application.find_by(token: params[:application_token])
    # Get the chat
    @chat = @app.chats.find_by(token: params[:token])
  end
end
