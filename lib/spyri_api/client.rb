# frozen_string_literal: true

require "json"
require "openssl"
require "uri"

module SpyriApi
  class Client

    SIGNATURE_SCHEME = "HMAC-SHA256"

    def initialize(config = {})
      set_config(config)
    end

    def set_config(config = {})
      @access_token = config[:access_token] || ''
      # HMAC credentials: when both are given, requests are signed and the access token is not used
      @access_uuid = config[:access_uuid]
      @secret = config[:secret]
      @host = config[:host] || ''

      timeout = config[:timeout] || 120
      @write_timeout = config[:write_timeout] || timeout
      @read_timeout = config[:read_timeout] || timeout
      @connect_timeout = config[:connect_timeout] || timeout
    end

    def call_api(http_method, path, opts = {})
      method = http_method.to_s.upcase
      # The query string is built here rather than by Excon, so that the signed path is exactly the one sent
      url = @host + path
      query = URI.encode_www_form(opts[:query_params] || {})
      url += "?#{query}" unless query.empty?
      body = method == "GET" ? "" : opts[:body].to_json

      headers = {'Content-Type' => "application/json"}
      headers.merge!(authentication_headers(method, URI(url).request_uri, body))

      conn = Excon.new(url, headers: headers, read_timeout: @read_timeout, write_timeout: @write_timeout, connect_timeout: @connect_timeout)

      res = nil
      case method
      when "POST", "PUT", "PATCH", "DELETE"
        res = conn.request(method: method, body: body)
      when "GET"
        res = conn.get
      end

      data = nil
      data = JSON.parse(res.body) if res.status == 200

      if (!data)
        return Error.new(res.status, res.body)
      end

      return data
    end

    private

    def hmac?
      !@access_uuid.to_s.empty? && !@secret.to_s.empty?
    end

    def authentication_headers(method, request_uri, body)
      # Legacy authentication: use Bearer token if HMAC credentials are not provided
      return { 'Authorization' => "Bearer #{@access_token}" } unless hmac?

      timestamp = Time.now.to_i.to_s
      string_to_sign = [method, request_uri, timestamp, OpenSSL::Digest::SHA256.hexdigest(body)].join("\n")
      signature = OpenSSL::HMAC.hexdigest('SHA256', @secret, string_to_sign)
      { 'Authorization' => "#{SIGNATURE_SCHEME} access_uuid=#{@access_uuid};time=#{timestamp};signature=#{signature}" }
    end

  end
end
