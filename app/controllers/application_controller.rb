# frozen_string_literal: true

class ApplicationController < ActionController::API
  def route_not_found
    render json: { error: 'Endpoint not found' }, status: :not_found
  end
end
