# frozen_string_literal: true

module Admin
  class EnrollmentsController < Admin::AdminController
    before_action :set_enrollment, only: %i[show edit update destroy]

    def index
      authorize! :read, Enrollment

      @enrollments = Enrollment.accessible(current_user)
                               .filtered(params[:school_id], params[:course_id], params[:batch_id], params[:student_id], params[:status])
                               .paginate(page: params[:page], per_page: 10)
    end

    def new
      authorize! :create, Enrollment

      @enrollment = Enrollment.new
    end

    def create
      @enrollment = Enrollment.new(enrollment_params)

      authorize! :create, @enrollment if @enrollment.batch

      if @enrollment.save
        redirect_to admin_enrollments_url, notice: 'Enrollment was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @enrollment

      @enrollment.update(enrollment_params)

      redirect_to request.referrer, notice: "Enrollment request was successfully #{@enrollment.status}."
    end

    def destroy
      authorize! :destroy, @enrollment

      @enrollment.destroy

      redirect_to admin_enrollments_url, notice: 'Enrollment was successfully destroyed.'
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
