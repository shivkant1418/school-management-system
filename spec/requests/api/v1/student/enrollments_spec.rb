# spec/requests/api/v1/student/enrollments_spec.rb

require 'swagger_helper'

RSpec.describe Api::V1::Student::EnrollmentsController, type: :request do
  path '/api/v1/student/enrollments' do
    get 'Retrieves a list of enrollments for the authenticated student user' do
      tags 'Student Enrollments'
      security [bearer_auth: []] # This line adds the Authorization field in Swagger UI
      consumes 'application/json'
      produces 'application/json'
      parameter name: :school_id, in: :query, type: :integer, description: 'Filter enrollments by school ID'
      parameter name: :course_id, in: :query, type: :integer, description: 'Filter enrollments by course ID'
      parameter name: :batch_id, in: :query, type: :integer, description: 'Filter enrollments by batch ID'
      parameter name: :status, in: :query, type: :string, description: 'Filter enrollments by status'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'list of enrollments retrieved' do
        let(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let(:batch) { create(:batch) }
        let(:enrollment) { create(:enrollment, student: user, batch: batch) }
        let(:school_id) { batch.course.school.id }
        let(:course_id) { batch.course.id }
        let(:batch_id) { batch.id }
        let(:status) { enrollment.status }
        let(:page) { 1 }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end  

  path '/api/v1/student/enrollments' do
    post 'Creates a new enrollment request for the authenticated student user' do
      tags 'Student Enrollments'
      security [bearer_auth: []] # This line adds the Authorization field in Swagger UI
      consumes 'application/json'
      produces 'application/json'
      parameter name: :enrollment, in: :body, schema: {
        type: :object,
        properties: {
          student_id: { type: :integer },
          batch_id: { type: :integer }
        },
        required: ['student_id', 'batch_id']
      }

      response '201', 'enrollment request created' do
        let(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let(:batch) { create(:batch) }
        let(:enrollment_params) { { enrollment: { student_id: user.id, batch_id: batch.id } } }

        let(:enrollment) { enrollment_params }

        run_test! do
          expect(response).to have_http_status(:created)
          expect(json_response['message']).to eq('Your enrollment request sent to school!')
        end
      end

      response '422', 'invalid request' do
        let(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let(:invalid_enrollment_params) { { enrollment: { student_id: user.id } } }

        let(:enrollment) { invalid_enrollment_params }


        run_test! do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_response['error']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/student/enrollments/{id}' do
    delete 'Withdraws an enrollment request for the authenticated student user' do
      tags 'Student Enrollments'
      security [bearer_auth: []] # This line adds the Authorization field in Swagger UI
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'enrollment request withdrawn' do
        let(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }
        let(:enrollment) { create(:enrollment, student: user) }
        let(:id) { enrollment.id }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['message']).to eq('Request successfully withdrawn.')
        end
      end

      response '404', 'enrollment not found' do
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
