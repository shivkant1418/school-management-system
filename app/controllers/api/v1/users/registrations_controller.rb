module Api
  module V1
    module Users
      class RegistrationsController < BaseController
        def create
          user = User.new(user_params)

          if user.save
            json_response({ type: 'success', message: 'User registered successfully.' }, :created)
          else
            json_response({ type: 'error', errors: user.errors.full_messages }, :unprocessable_entity)
          end
        end

        private

        def user_params
          params.permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
