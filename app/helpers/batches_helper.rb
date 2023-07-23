# frozen_string_literal: true

module BatchesHelper
  def batch_enrollment_status_badge(status)
    badge_name = case status
                 when 'enrolled'
                   'bg-success'
                 when 'request sent'
                   'bg-warning'
                 end

    "<span class='badge #{badge_name}'>#{status.titleize}</span>".html_safe
  end
end
