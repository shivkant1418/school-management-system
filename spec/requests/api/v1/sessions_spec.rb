require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  path '/api/v1/signin' do
    post 'Authenticate user and get JWT token' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@example.com' },
          password: { type: :string, example: 'password' }
        },
        required: ['email', 'password']
      }

      response '200', 'successful authentication' do
        let(:user) do
          {
            email: 'test@example.com',
            password: 'password'
          }
        end

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['token']).not_to be_empty
          expect(json_response['exp']).not_to be_empty
        end
      end

      response '401', 'unauthorized' do
        let(:user) do
          {
            email: 'test@example.com',
            password: 'wrong_password'
          }
        end

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          expect(json_response['error']).to eq('Invalid email or password')
        end
      end
    end
  end
end
