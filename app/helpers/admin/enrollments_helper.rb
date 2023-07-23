# frozen_string_literal: true

module Admin
  module EnrollmentsHelper
    def enrollment_status_badge(status)
      badge_name = case status
                   when 'approved'
                     'bg-success'
                   when 'enrolled'
                     'bg-success'
                   when 'rejected'
                     'bg-danger'
                   when 'pending'
                     'bg-warning'
                   when 'request sent'
                     'bg-warning'
                   end

      "<span class='badge #{badge_name}'>#{status.titleize}</span>".html_safe
    end
  end
end
