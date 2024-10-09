# frozen_string_literal: true

class EndpointsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  def index
    render json: Endpoint.all
  end

  def create
    endpoint = Endpoint.new(endpoint_params)
    return render json: endpoint, status: :created if endpoint.save

    render json: { errors: endpoint.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    endpoint = Endpoint.find(params[:id])
    endpoint.update!(endpoint_params)
    Rails.application.reload_routes!
    render json: { message: 'Endpoint updated' }, status: :ok
  end

  def destroy
    endpoint = Endpoint.find(params[:id])
    endpoint.destroy
    Rails.application.reload_routes!
    render json: { message: 'Endpoint deleted' }, status: :ok
  end

  private

  def endpoint_params
    params.require(:data).require(:attributes).permit(:verb, :path, response: [:code, { headers: {} }, :body])
  end

  def record_not_found
    render json: { error: 'Endpoint not found' }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
