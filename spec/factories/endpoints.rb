# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint do
    id { SecureRandom.uuid }
    verb { 'GET' }
    path { '/greeting' }
    response do
      {
        'code' => 200,
        'headers' => { 'Custom-Header' => 'CustomValue' },
        'body' => '{ "message": "Hello, world" }'
      }
    end
  end
end
