# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: :show

  def index
    authorize! :read, Course

    @courses = Course.accessible(current_user)
                     .filtered(params[:school_id], params[:course_name])
                     .paginate(page: params[:page], per_page: 10)
  end

  def show
    authorize! :read, CoursesController
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end
end
