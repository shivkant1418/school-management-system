# frozen_string_literal: true

module Admin
  class SchoolsController < Admin::AdminController
    before_action :set_school, only: %i[show edit update destroy]

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

    def new
      authorize! :create, School

      @school = School.new
    end

    def edit
      authorize! :update, @school
    end

    def create
      authorize! :create, School
      @school = School.new(school_params)

      if @school.save
        redirect_to admin_school_url(@school), notice: 'School was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      authorize! :update, @school

      if @school.update(school_params)
        redirect_to admin_school_url(@school), notice: 'School was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize! :destroy, @school

      @school.destroy

      redirect_to admin_schools_url, notice: 'School was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :description, :address)
    end
  end
end
