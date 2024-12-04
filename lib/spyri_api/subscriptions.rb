# frozen_string_literal: true

module SpyriApi
  class Subscriptions

    BASEPATH = '/subscriptions'.freeze
    SEARCHABLE_ATTRIBUTES = [:erp_id].freeze

    attr_accessor :api_client

    def initialize(api_client)
      @api_client = api_client
    end

    def search(opts = {})
      query_params = {}
      SEARCHABLE_ATTRIBUTES.each do |key|
        query_params[key.to_s] = opts[key] if !opts[key].nil?
      end
      path = BASEPATH
      @api_client.call_api(:GET, path, query_params: query_params)
    end

    def get(id)
      path = "#{BASEPATH}/#{id}"
      @api_client.call_api(:GET, path)
    end

    def create(subscription_object)
      path = BASEPATH
      @api_client.call_api(:POST, path, body: { subscription: subscription_object })
    end

    def update(id, subscription_object)
      path = "#{BASEPATH}/#{id}"
      @api_client.call_api(:PATCH, path, body: { subscription: subscription_object })
    end

    def terminate(id)
      path = "#{BASEPATH}/#{id}/terminate"
      @api_client.call_api(:PATCH, path)
    end

  end
end