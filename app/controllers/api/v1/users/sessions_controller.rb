module Api
  module V1
    module Users
      class SessionsController < BaseController
        def create
          user = User.find_by(email: params[:email])

          if user&.valid_password?(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            time = Time.now + 24.hours.to_i

            json_response({ type: 'success', data: { id: user.id, email: user.email, token: token, exp: time.strftime("%m-%d-%Y %H:%M") } })
          else
            json_response({ error: 'Invalid email or password' }, :unauthorized)
          end
        end
      end
    end
  end
end
