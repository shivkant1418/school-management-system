require 'swagger_helper'

RSpec.describe "Api::V1::Courses", type: :request do
  path '/api/v1/courses' do
    get 'Retrieve a list of courses' do
      tags 'Courses'
      consumes 'application/json'
      parameter name: :school_id, in: :query, type: :integer, description: 'Filter courses by school ID'
      parameter name: :course_name, in: :query, type: :string, description: 'Filter courses by name'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination'

      response '200', 'successful response' do
        let!(:school) { create(:school) }
        let!(:course) { create(:course, school: school) }

        let(:school_id) { school.id }
        let(:course_name) { course.name }
        let(:page) { 1 }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
        end
      end
    end
  end

  path '/api/v1/courses/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Course ID'

    get 'Retrieve a course by ID' do
      tags 'Courses'
      consumes 'application/json'

      response '200', 'successful response' do
        let(:course) { create(:course) }
        let(:id) { course.id }

        run_test! do
          expect(response).to have_http_status(:ok)
          expect(json_response['data']).not_to be_empty
          expect(json_response['data']['id']).to eq(course.id)
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
