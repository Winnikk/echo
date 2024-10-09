# frozen_string_literal: true

class EchosController < ApplicationController
  def show
    endpoint = Endpoint.find_by(path: request.path, verb: request.method)

    response_data = endpoint.response

    response_data['headers'].each do |key, value|
      response.headers[key] = value
    end

    render json: JSON.parse(response_data['body']), status: response_data['code']
  end
end
