require 'swagger_helper'

RSpec.describe Api::V1::Student::CoursesController, type: :request do
  path '/api/v1/student/courses' do
    get 'Retrieves a list of courses for the authenticated student user' do
      tags 'Student Courses'
      security [bearer_auth: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :school_id, in: :query, type: :integer, description: 'Filter courses by school ID'
      parameter name: :course_name, in: :query, type: :string, description: 'Filter courses by name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'list of courses retrieved' do
        let!(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }

        let!(:batch) { create(:batch) }
        let!(:enrollment) { create(:enrollment, student: user, batch: batch, status: "approved") }

        let(:school_id) { batch.course.school.id }
        let(:course_name) { batch.course.name }
        let(:page) { 1 }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/student/courses/{id}' do
    get 'Retrieves a course by ID for the authenticated student user' do
      tags 'Student Courses'
      security [bearer_auth: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'course retrieved' do
        let!(:user) { create(:user, :student) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }

        let!(:batch) { create(:batch) }
        let!(:enrollment) { create(:enrollment, student: user, batch: batch, status: "approved") }

        let(:id) { batch.course.id }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
          expect(json_response['data']['id']).to eq(batch.course.id)
        end
      end

      response '404', 'course not found' do
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
