module Api
  module V1
    class BaseController < ActionController::API
      include ::ActionController::Serialization
      include Response
      include ExceptionHandler

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last

        return json_response({ error: 'Oops! It looks like you need to sign in before accessing this.' }, :unauthorized) unless token

        decoded_token = JsonWebToken.decode(token)

        if decoded_token && !token_expired?(decoded_token)
          @current_user = User.find(decoded_token['user_id'])
        else
          json_response({ error: 'Oops! It looks like you need to sign in before accessing this.' }, :unauthorized)
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
end

