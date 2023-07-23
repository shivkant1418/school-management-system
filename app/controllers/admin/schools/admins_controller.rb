# frozen_string_literal: true

module Admin
  module Schools
    class AdminsController < Admin::AdminController
      before_action :set_school
      before_action :set_school_admin, only: :destroy

      def index
        authorize! :read, School::Admin
      end

      def new
        authorize! :read, School::Admin

        @school_admin = @school.school_admins.new
      end

      def create
        authorize! :read, School::Admin

        @school_admin = @school.school_admins.new(school_admin_params)

        if @school.save
          redirect_to admin_school_admins_path(@school), notice: 'School Admin was successfully created.'
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :read, School::Admin

        @school_admin.destroy

        redirect_to admin_school_admins_path(@school), notice: 'School Admin was successfully removed.'
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_school
        @school = School.find(params[:school_id])
      end

      def set_school_admin
        @school_admin = @school.school_admins.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def school_admin_params
        params.require(:school_admin).permit(:school_id, :user_id, :role_ids)
      end
    end
  end
end
