# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authorize_admin!
    skip_before_action :non_admin_access!

    layout 'admin/layouts/application'

    private

    def authorize_admin!
      authorize! :access, :admin_panel
    end
  end
end
