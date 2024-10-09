# frozen_string_literal: true

Rails.application.routes.draw do
  resources :endpoints, only: %i[index create update destroy]

  if ActiveRecord::Base.connection.table_exists? 'endpoints'
    Endpoint.find_each do |endpoint|
      match endpoint.path, to: 'echos#show', via: endpoint.verb.downcase.to_sym, as: "dynamic_#{endpoint.id}"
    end
  end

  match '*unmatched', to: 'application#route_not_found', via: :all
end
