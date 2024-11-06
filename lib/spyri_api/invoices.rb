# frozen_string_literal: true

module SpyriApi
  class Invoices

    BASEPATH = '/invoices'.freeze

    attr_accessor :api_client

    def initialize(api_client)
      @api_client = api_client
    end

    def search(opts = {})
      query_params = {}
      [:code, :subscription_id, :user_id].each do |key|
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

  end
end