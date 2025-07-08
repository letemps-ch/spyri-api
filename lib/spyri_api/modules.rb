# frozen_string_literal: true

module SpyriApi
  class Modules

    BASEPATH = '/modules'.freeze
    SEARCHABLE_ATTRIBUTES = [:sirius_id, :title].freeze

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

  end
end