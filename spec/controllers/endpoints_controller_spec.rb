# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointsController, type: :request do
  let!(:endpoint) { create(:endpoint) }

  before do
    Rails.application.reload_routes!
  end

  describe 'GET /endpoints' do
    it 'returns a list of endpoints' do
      get '/endpoints'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
      expect(JSON.parse(response.body).size).to eq(Endpoint.count)
    end
  end

  describe 'POST /endpoints' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'POST',
              path: '/new_endpoint',
              response: {
                code: 201,
                headers: { 'Custom-Header' => 'CustomValue' },
                body: '{ "message": "Created" }'
              }
            }
          }
        }
      end

      it 'creates a new endpoint' do
        expect do
          post '/endpoints', params: valid_params, as: :json
        end.to change(Endpoint, :count).by(1)

        expect(response).to have_http_status(:created)

        response_body = JSON.parse(response.body)
        expect(response_body).to include(
          'id' => a_kind_of(String),
          'verb' => 'POST',
          'path' => '/new_endpoint',
          'response' => {
            'code' => 201,
            'headers' => { 'Custom-Header' => 'CustomValue' },
            'body' => '{ "message": "Created" }'
          }
        )
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: '',
              path: '',
              response: {
                code: 201,
                headers: { 'Custom-Header' => 'CustomValue' },
                body: '{ "message": "Created" }'
              }
            }
          }
        }
      end

      it 'does not create a new endpoint and returns errors' do
        expect do
          post '/endpoints', params: invalid_params, as: :json
        end.not_to change(Endpoint, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'PUT /endpoints/:id' do
    context 'with valid parameters' do
      let(:valid_update_params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'PUT',
              path: '/updated_endpoint',
              response: {
                code: 200,
                headers: { 'Custom-Header' => 'UpdatedValue' },
                body: '{ "message": "Updated" }'
              }
            }
          }
        }
      end

      it 'updates the endpoint' do
        put "/endpoints/#{endpoint.id}", params: valid_update_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Endpoint updated')

        endpoint.reload
        expect(endpoint.path).to eq('/updated_endpoint')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: '',
              path: '',
              response: {
                code: 200,
                headers: { 'Custom-Header' => 'UpdatedValue' },
                body: '{ "message": "Updated" }'
              }
            }
          }
        }
      end

      it 'does not update the endpoint and returns errors' do
        put "/endpoints/#{endpoint.id}", params: invalid_update_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end

    context 'when the endpoint does not exist' do
      let(:valid_update_params) do
        {
          data: {
            type: 'endpoints',
            attributes: {
              verb: 'PUT',
              path: '/updated_endpoint',
              response: {
                code: 200,
                headers: { 'Custom-Header' => 'UpdatedValue' },
                body: '{ "message": "Updated" }'
              }
            }
          }
        }
      end

      it 'returns a not found response' do
        put '/endpoints/invalid_id', params: valid_update_params, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('error' => 'Endpoint not found')
      end
    end
  end

  describe 'DELETE /endpoints/:id' do
    it 'deletes the endpoint' do
      delete "/endpoints/#{endpoint.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include('message' => 'Endpoint deleted')
      expect(Endpoint.exists?(endpoint.id)).to be_falsey
    end

    context 'when the endpoint does not exist' do
      it 'returns a not found response' do
        delete '/endpoints/invalid_id'

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('error' => 'Endpoint not found')
      end
    end
  end
end
