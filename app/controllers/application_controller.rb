# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :non_admin_access!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { render 'content_pages/not_found' }
    end
  end

  private

  def not_found
    render 'content_pages/not_found', status: :not_found
  end

  def non_admin_access!
    redirect_to admin_path if current_user && (current_user.has_role?(:admin) || current_user.has_role?(:school_admin))
  end
end
