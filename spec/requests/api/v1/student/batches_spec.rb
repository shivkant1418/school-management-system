require 'swagger_helper'

RSpec.describe Api::V1::Student::BatchesController, type: :request do
  path '/api/v1/student/batches' do
    get 'Retrieves a list of batches for the authenticated student user' do
      tags 'Student Batches'
      security [bearer_auth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :school_id, in: :query, type: :integer, description: 'Filter batches by school ID'
      parameter name: :course_id, in: :query, type: :integer, description: 'Filter batches by course ID'
      parameter name: :batch_name, in: :query, type: :string, description: 'Filter batches by name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'list of batches retrieved' do
        let!(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let!(:batch) { create(:batch) }
        let!(:enrollment) { create(:enrollment, student: user, batch: batch) }
        let(:Authorization) { "Bearer #{token}" }

        let!(:course) { create(:course) }
        let!(:batch1) { create(:batch, course: course, name: 'Batch 1') }
        let!(:batch2) { create(:batch, course: course, name: 'Batch 2') }
        let!(:enrollment) { create(:enrollment, batch: batch1, student: user, status: "approved") }

        let(:school_id) { course.school.id }
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

  path '/api/v1/student/batches/{id}' do
    get 'Retrieves a batch by ID for the authenticated student user' do
      tags 'Student Batches'
      security [bearer_auth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'batch retrieved' do
        let!(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let!(:batch) { create(:batch) }
        let(:id) { batch.id }
        let!(:enrollment) { create(:enrollment, batch: batch, student: user, status: "approved") }
        let(:id) { batch.id }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end

      response '404', 'batch not found' do
        let(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { 123 }

        run_test! do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
