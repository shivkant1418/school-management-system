module Api
  class SchoolsController < BaseController
    before_action :set_school, only: :show

    def index
      authorize! :read, School

      @schools = School.accessible(current_user)
                      .filtered(params[:school_name])
                      .order(created_at: :desc)
                      .paginate(page: params[:page], per_page: 2)

      pagination_json_response(@schools)
    end

    def show
      authorize! :read, @school

      json_response(@school)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end
  end
end
