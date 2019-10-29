# frozen_string_literal: true

# Home Controller used to return the index page of the app
class HomeController < ApplicationController
  def index
    # Might be useful to create a json object with all required information. Such as status.endpoints for the available endpoints
    msg = { Status: 'This is the main page of the API. More instructions will be added shortly!' }

    render json: msg
  end

  def job
    # Get status of a job by id
    @data = Sidekiq::Status.get_all params[:jid]

    # Render @data to the client
    render json: @data
  end
end
