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

  # "HMAC-SHA256 access_uuid=…;time=…;signature=…" => { "access_uuid" => …, "time" => …, "signature" => … }
  def authorization_params(request)
    request[:headers]["Authorization"].delete_prefix("HMAC-SHA256 ").split(";").to_h { |param| param.split("=", 2) }
  end

  def expected_signature(request)
    string_to_sign = [
      request[:method].to_s.upcase,
      signed_path(request),
      authorization_params(request)["time"],
      OpenSSL::Digest::SHA256.hexdigest(request[:body].to_s)
    ].join("\n")
    OpenSSL::HMAC.hexdigest('SHA256', secret, string_to_sign)
  end

  context "with HMAC credentials" do
    let(:client) { described_class.new(access_uuid: "KEY", secret: secret, host: "https://example.com/api") }

    it "signs a GET with its query string, including the host path" do
      SpyriApi::Users.new(client).search(email: "jane@example.com")
      request = requests.last

      expect(signed_path(request)).to eq("/api/users?email=jane%40example.com")
      expect(request[:headers]["Authorization"]).to start_with("HMAC-SHA256 ")
      expect(authorization_params(request).keys).to eq(%w[access_uuid time signature])
      expect(authorization_params(request)["access_uuid"]).to eq("KEY")
      expect(authorization_params(request)["time"].to_i).to be_within(5).of(Time.now.to_i)
      expect(authorization_params(request)["signature"]).to eq(expected_signature(request))
    end

    it "signs the body of a write" do
      SpyriApi::Users.new(client).create(email: "jane@example.com")
      request = requests.last

      expect(request[:body]).to eq({ user: { email: "jane@example.com" } }.to_json)
      expect(authorization_params(request)["signature"]).to eq(expected_signature(request))
    end
  end

  context "without HMAC credentials" do
    let(:client) { described_class.new(access_token: "TOKEN", host: "https://example.com/api") }

    it "sends the access token as a bearer" do
      SpyriApi::Users.new(client).get(42)
      request = requests.last

      expect(request[:headers]["Authorization"]).to eq("Bearer TOKEN")
    end
  end
end
