# frozen_string_literal: true

class Endpoint < ApplicationRecord
  VALID_HTTP_VERBS = %w[GET POST PUT PATCH DELETE OPTIONS HEAD].freeze
  VALID_HTTP_CODES = (100..599).to_a.freeze

  before_validation :set_uuid, on: :create

  validates :id, presence: true, uniqueness: true
  validates :verb, presence: true, uniqueness: { scope: :path, message: 'and path combination must be unique.' },
                   inclusion: { in: VALID_HTTP_VERBS, message: 'must be a valid HTTP request method.' }
  validates :path, presence: true, format: { with: %r{\A/[^/]+\z} }
  validates :response, presence: true

  validate :validate_response_code
  validate :validate_response_body
  validate :validate_response_headers

  private

  def set_uuid
    self.id ||= SecureRandom.uuid
  end

  def validate_response_code
    code = response['code']
    return if VALID_HTTP_CODES.include?(code)

    errors.add(:response, 'code must be a valid HTTP status code between 100 and 599.')
  end

  def validate_response_body
    body = response['body']
    begin
      JSON.parse(body)
    rescue JSON::ParserError
      errors.add(:response, 'body must be a valid JSON string.')
    end
  end

  def validate_response_headers
    headers = response['headers']
    return if headers.is_a?(Hash)

    errors.add(:response, 'headers must be a hash.')
  end
end
