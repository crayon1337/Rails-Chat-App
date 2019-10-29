# frozen_string_literal: true

# Messages Controller used to create the CRUD functionalities of /applications/:application_token/chats/:chat_token/messages
class MessagesController < ApplicationController
  before_action :load_entities

  def index
    # Get messages of chat!
    @messages = @chat.messages.all

    # Render the response as an JSON object
    render json: @messages
  end

  def create
    # Get the last ID +1
    @messagenumber = Message.where(chat_id: @chat.id)
                            .pluck(Arel.sql('coalesce(max(token)+1, 1)')).first

    if params[:body] && params[:sender]
      # Start the worker
      job_id = MessagesWorker.perform_async params[:sender], params[:body], @messagenumber, params[:application_token], params[:chat_token]

      # Set the successful return value
      returnvalue = { Status: 'Success', Message: 'Your message is being processed by our server', MessageNumber: @messagenumber, ChatNumber: params[:chat_token], ApplicationToken: params[:application_token], JobID: job_id }

      status = 200
    else
      # Set the failure return value
      returnvalue = { Status: 'Failed', Message: 'Every message needs a body and a sender name.' }

      status = 422
    end

    # Respond to the client
    render json: returnvalue, status: status
  end

  def show
    # Render the @message as JSON object
    render json: @message
  end

  def update
    # Set the message body
    @message.body = params[:body]

    # Set the response based on @message.save
    if @message.save
      msg = { Status: 'Success', Message: 'Message body has been changed', MessageNumber: @message.token, ApplicationToken: @app.token }
      status = 200
    else
      msg = { Status: 'Failled', MessageNumber: @message.token, ApplicationToken: @app.token }
      status = 422
    end

    render json: msg, status: status
  end

  def destroy
    # Destroy the message
    @message.destroy

    if @message.destroyed?
      msg = { Status: 'Success', Message: 'Message has been deleted!', MessageNumber: @message.token, ApplicationToken: @app.token }
      status = 200
    else
      msg = { Message: 'Could not delete the message' }
      status = 422
    end

    render json: msg, status: status
  end

  private

  def message_params
    params.permit(:sender, :body)
  end

  protected

  def load_entities
    # Get the application by token
    @app = Application.find_by(token: params[:application_token])

    # Get the chat by chat_id
    @chat = @app.chats.find_by(token: params[:chat_token])

    # Get the message
    @message = @chat.messages.find_by(token: params[:token])
  end
end
