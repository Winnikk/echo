# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Echos API', type: :request do
  describe 'GET /greeting' do
    context 'when the endpoint exists' do
      before do
        create(:endpoint)
        Rails.application.reload_routes!
      end

      it 'returns a successful response with the correct body and custom headers' do
        get '/greeting'

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to eq('message' => 'Hello, world')
        expect(response.headers['Custom-Header']).to eq('CustomValue')
      end
    end

    context 'when the endpoint does not exist' do
      before { Rails.application.reload_routes! }

      it 'returns a not found response' do
        get '/greeting'

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('error' => 'Endpoint not found')
      end
    end
  end
end
