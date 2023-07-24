require 'swagger_helper'

RSpec.describe "Api::V1::Registrations", type: :request do
  path '/api/v1/users/signup' do
    post 'Register a new user' do
      tags 'Registrations'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@example.com' },
          password: { type: :string, example: 'password' },
          password_confirmation: { type: :string, example: 'password' }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response '201', 'user registered successfully' do
        let(:user) do
          {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        end

        run_test! do
          expect(response).to have_http_status(:created)
          expect(json_response['type']).to eq('success')
          expect(json_response['message']).to eq('User registered successfully.')
        end
      end

      response '422', 'unprocessable entity' do
        let(:user) do
          {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'wrong_password'
          }
        end

        run_test! do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['type']).to eq('error')
          expect(json_response['errors']).to include("Password confirmation doesn't match Password")
        end
      end
    end
  end
end
