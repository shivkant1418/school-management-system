# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :set_school, only: :show

  def index
    authorize! :read, School

    @schools = School.accessible(current_user)
                     .filtered(params[:school_name])
                     .order(created_at: :desc)
                     .paginate(page: params[:page], per_page: 10)
  end

  def show
    authorize! :read, @school
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end
end
