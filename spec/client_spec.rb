# frozen_string_literal: true

require "excon"

RSpec.describe SpyriApi::Client do
  let(:secret) { "s3cr3t" }
  let(:requests) { [] }

  before do
    Excon.defaults[:mock] = true
    Excon.stub({}, lambda { |params|
      requests << params
      { status: 200, body: { ok: true }.to_json }
    })
  end

  after do
    Excon.stubs.clear
    Excon.defaults[:mock] = false
  end

  def signed_path(request)
    request[:query].to_s.empty? ? request[:path] : "#{request[:path]}?#{request[:query]}"
  end

  def expected_signature(request)
    string_to_sign = [
      request[:method].to_s.upcase,
      signed_path(request),
      request[:headers]["X-API-Timestamp"],
      OpenSSL::Digest::SHA256.hexdigest(request[:body].to_s)
    ].join("\n")
    "sha256=#{OpenSSL::HMAC.hexdigest('SHA256', secret, string_to_sign)}"
  end

  context "with HMAC credentials" do
    let(:client) { described_class.new(key_id: "KEY", secret: secret, host: "https://example.com/api") }

    it "signs a GET with its query string, including the host path" do
      SpyriApi::Users.new(client).search(email: "jane@example.com")
      request = requests.last

      expect(signed_path(request)).to eq("/api/users?email=jane%40example.com")
      expect(request[:headers]["Authorization"]).to eq("HMAC-SHA256 KeyId=KEY")
      expect(request[:headers]["X-API-Signature"]).to eq(expected_signature(request))
    end

    it "signs the body of a write" do
      SpyriApi::Users.new(client).create(email: "jane@example.com")
      request = requests.last

      expect(request[:body]).to eq({ user: { email: "jane@example.com" } }.to_json)
      expect(request[:headers]["X-API-Signature"]).to eq(expected_signature(request))
    end
  end

  context "without HMAC credentials" do
    let(:client) { described_class.new(access_token: "TOKEN", host: "https://example.com/api") }

    it "sends the access token as a bearer" do
      SpyriApi::Users.new(client).get(42)
      request = requests.last

      expect(request[:headers]["Authorization"]).to eq("Bearer TOKEN")
      expect(request[:headers]).not_to have_key("X-API-Signature")
    end
  end
end
