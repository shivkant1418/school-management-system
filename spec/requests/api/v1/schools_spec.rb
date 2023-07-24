require 'swagger_helper'

RSpec.describe "Api::V1::Schools", type: :request do
  path '/api/v1/schools' do
    get 'Retrieve a list of schools' do
      tags 'Schools'
      consumes 'application/json'
      parameter name: :school_name, in: :query, type: :string, description: 'Filter schools by name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'successful response' do
        let!(:school) { create(:school) }

        let(:school_name) { school.name }
        let(:page) { 1 }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/schools/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'School ID'

    get 'Retrieve a school by ID' do
      tags 'Schools'
      consumes 'application/json'

      response '200', 'successful response' do
        let(:school) { create(:school) }
        let(:id) { school.id }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
          expect(json_response['data']['id']).to eq(school.id)
        end
      end

      response '404', 'not found' do
        let(:id) { 999 }

        run_test! do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
