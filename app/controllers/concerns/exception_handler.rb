module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from JWT::DecodeError, JWT::ExpiredSignature  do |e|
      json_response({ message: e.message }, :unauthorized)
    end

    rescue_from CanCan::AccessDenied  do |e|
      json_response({ message: e.message }, :forbidden)
    end
  end
end