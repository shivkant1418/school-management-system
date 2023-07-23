# frozen_string_literal: true

module Admin
  class CoursesController < Admin::AdminController
    before_action :set_course, only: %i[show edit update destroy]

    def index
      authorize! :read, Course

      @courses = Course.accessible(current_user)
                       .filtered(params[:school_id], params[:course_name])
                       .paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.json { render json: { courses: @courses } }
      end
    end

    def show
      authorize! :read, @course
    end

    def new
      authorize! :create, Course

      @course = Course.new
    end

    def edit
      authorize! :update, @course
    end

    def create
      @course = Course.new(course_params)

      authorize! :create, @course if @course.school

      if @course.save
        redirect_to params[:redirect_page] == "school" ? admin_school_url(@course.school) : admin_course_url(@course), notice: 'Course was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @course

      if @course.update(course_params)
        redirect_to params[:redirect_page] == "school" ? admin_school_url(@course.school) : admin_course_url(@course), notice: 'Course was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! :destroy, @course

      @course.destroy

      redirect_to admin_courses_url, notice: 'Course was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :school_id)
    end
  end
end
