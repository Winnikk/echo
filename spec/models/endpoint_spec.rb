# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  subject { create(:endpoint) }

  describe 'validations' do
    it { should validate_presence_of(:id) }
    it { should validate_uniqueness_of(:id) }
    it { should validate_presence_of(:verb) }
    it { should validate_uniqueness_of(:verb).scoped_to(:path).with_message('and path combination must be unique.') }
    it {
      should validate_inclusion_of(:verb).in_array(Endpoint::VALID_HTTP_VERBS).with_message('must be a valid HTTP request method.')
    }
    it { should validate_presence_of(:path) }
  end

  describe 'custom validations' do
    context 'when the response code is invalid' do
      before { subject.response['code'] = 999 }

      it 'adds an error for invalid response code' do
        subject.valid?
        expect(subject.errors[:response]).to include('code must be a valid HTTP status code between 100 and 599.')
      end
    end

    context 'when the response body is invalid JSON' do
      before { subject.response['body'] = '{ invalid_json }' }

      it 'adds an error for invalid response body' do
        subject.valid?
        expect(subject.errors[:response]).to include('body must be a valid JSON string.')
      end
    end

    context 'when the response headers are not a hash' do
      before { subject.response['headers'] = 'not_a_hash' }

      it 'adds an error for headers not being a hash' do
        subject.valid?
        expect(subject.errors[:response]).to include('headers must be a hash.')
      end
    end
  end
end
