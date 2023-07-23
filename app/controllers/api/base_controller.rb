module Api
  class BaseController < ActionController::API
    include Response
    include ExceptionHandler

    private

    def authenticate_user
      token = request.headers['Authorization']&.split(' ')&.last
      return head :unauthorized unless token

      decoded_token = JsonWebToken.decode(token)

      if decoded_token && !token_expired?(decoded_token)
        @current_user = User.find(decoded_token['user_id'])
      else
        json_response({}, :unauthorized)
      end
    end

    def token_expired?(decoded_token)
      Time.at(decoded_token['exp']) < Time.now
    end

    def current_user
      @current_user
    end
  end
end

