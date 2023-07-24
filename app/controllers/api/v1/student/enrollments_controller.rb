# frozen_string_literal: true
module Api
  module V1
    module Student
      class EnrollmentsController < BaseController
        before_action :authenticate_user!
        before_action :set_enrollment, only: :destroy

        def index
          authorize! :read, Enrollment

          @enrollments = Enrollment.accessible(current_user)
                                  .filtered(params[:school_id], params[:course_id], params[:batch_id], nil, params[:status])
                                  .paginate(page: params[:page], per_page: 10)

          pagination_json_response(@enrollments)
        end

        def create
          authorize! :create, Enrollment

          @enrollment = Enrollment.new(enrollment_params.merge!(student_id: current_user.id))

          if @enrollment.save
            json_response({ message: 'Your enrollment request sent to school!' }, :created)
          else
            json_response({ error: @enrollment.errors.full_messages }, :unprocessable_entity)
          end
        end

        def destroy
          authorize! :destroy, @enrollment

          @enrollment.destroy

          json_response({ message: 'Request successfully withdrawn.' })
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_enrollment
          @enrollment = Enrollment.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def enrollment_params
          params.require(:enrollment).permit(:student_id, :batch_id, :status)
        end
      end
    end
  end
end
