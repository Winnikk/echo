# frozen_string_literal: true

class CreateEndpoints < ActiveRecord::Migration[7.1]
  def change
    create_table :endpoints, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :verb, null: false
      t.string :path, null: false
      t.json :response, default: {}

      t.timestamps
    end

    add_index :endpoints, %i[verb path], unique: true
  end
end
