# spec/lib/json_web_token_spec.rb
require 'rails_helper'

RSpec.describe JsonWebToken do
  describe '.encode' do
    it 'encodes a payload with an expiration time' do
      payload = { user_id: 1 }
      expiration = 1.hour.from_now
      token = JsonWebToken.encode(payload, expiration)

      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      payload = { user_id: 1 }
      expiration = 1.hour.from_now
      token = JsonWebToken.encode(payload, expiration)

      decoded_payload = JsonWebToken.decode(token)

      expect(decoded_payload).to be_a(HashWithIndifferentAccess)
      expect(decoded_payload[:user_id]).to eq(payload[:user_id])
    end

    it 'raises an error for an invalid token' do
      expect {
        JsonWebToken.decode('invalid_token')
      }.to raise_error(JWT::DecodeError)
    end
  end
end
