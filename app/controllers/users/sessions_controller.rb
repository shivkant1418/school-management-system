# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :non_admin_access!
  end
end
