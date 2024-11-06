# frozen_string_literal: true

module SpyriApi
  class Users

    BASEPATH = '/users'.freeze

    attr_accessor :api_client

    def initialize(api_client)
      @api_client = api_client
    end

    def search(opts = {})
      query_params = {}
      [:email, :name, :phone_number, :erp_id].each do |key|
        query_params[key.to_s] = opts[key] if !opts[key].blank?
      end
      path = BASEPATH
      data = @api_client.call_api(:GET, path, query_params: query_params)
      return data
    end

    def get(id)
      path = "#{BASEPATH}/#{id}"
      data = @api_client.call_api(:GET, path)
      return data
    end

    def create(user_object)
      path = BASEPATH
      data = @api_client.call_api(:POST, path, body: { user: user_object })
    end

    def update(id, user_object)
      path = "#{BASEPATH}/#{id}"
      data = @api_client.call_api(:PATCH, path, body: { user: user_object })
    end

  end
end