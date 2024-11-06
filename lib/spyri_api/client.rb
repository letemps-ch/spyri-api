# frozen_string_literal: true

module SpyriApi
  class Client

    def initialize(config = {})
      set_config(config)
    end

    def set_config(config = {})
      @access_token = config[:access_token] || ''
      @host = config[:host] || ''

      timeout = config[:timeout] || 120
      @write_timeout = config[:write_timeout] || timeout
      @read_timeout = config[:read_timeout] || timeout
      @connect_timeout = config[:connect_timeout] || timeout
    end

    def call_api(http_method, path, opts = {})
      headers = {'Content-Type' => "application/json"}
      headers[:Authorization] = "Bearer #{@access_token}"

      conn = Excon.new(@host + path, headers: headers, read_timeout: @read_timeout, write_timeout: @write_timeout, connect_timeout: @connect_timeout)

      res = nil
      case http_method.to_sym.downcase
      when :post, :put, :patch, :delete
        res = conn.request(method: http_method, query: opts[:query_params], body: opts[:body].to_json)
      when :get
        res = conn.get(query: opts[:query_params])
      end

      data = nil
      data = JSON.parse(res.body) if res.status == 200

      if (!data)
        return Error.new(res.status, res.body)
      end

      return data
    end

  end
end