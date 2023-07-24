require 'swagger_helper'

RSpec.describe "Api::V1::Batches", type: :request do
  path '/api/v1/batches' do
    get 'Retrieve a list of batches' do
      tags 'Batches'
      consumes 'application/json'
      parameter name: :school_id, in: :query, type: :integer, description: 'Filter batches by school ID'
      parameter name: :course_id, in: :query, type: :integer, description: 'Filter batches by course ID'
      parameter name: :batch_name, in: :query, type: :string, description: 'Filter batches by name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'successful response' do
        let!(:school) { create(:school) }
        let!(:course) { create(:course, school: school) }
        let!(:batch1) { create(:batch, course: course, name: 'Batch 1') }
        let!(:batch2) { create(:batch, course: course, name: 'Batch 2') }

        let(:school_id) { school.id }
        let(:course_id) { course.id }
        let(:batch_name) { batch1.name }
        let(:page) { 1 }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end
end
