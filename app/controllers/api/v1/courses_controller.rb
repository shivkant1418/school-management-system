# frozen_string_literal: true

module Api
  module V1
    class CoursesController < BaseController
      before_action :set_course, only: :show

      def index
        authorize! :read, Course

        @courses = Course.accessible(current_user)
                        .filtered(params[:school_id], params[:course_name])
                        .paginate(page: params[:page], per_page: 10)

        pagination_json_response(@courses)
      end

      def show
        authorize! :read, CoursesController

        json_response(data: @course)
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_course
        @course = Course.find(params[:id])
      end
    end
  end
end
