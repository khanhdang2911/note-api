module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorized_refresh_token, only: [ :refresh_token ]
      def register
        user = User.new user_params
        user.refresh_token = JwtService.generate_refresh_token
        if user.save
          json_response user, "Register successfully!", :created
        else
          json_error_response user.errors.full_messages
        end
      end

      def login
        user = User.find_by email: params[:email]
        if user&.authenticate params[:password]
          payload = { user_id: user.id }
          access_token = JwtService.encode_token payload
          cookies.encrypted[:refresh_token] = {
            value: user.refresh_token,
            httponly: true,
            secure: false,
            same_site: :lax,
            expires: 1.month.from_now
          }
          json_response ({ access_token: access_token }), "Login successfully!", :ok
        else
          json_error_response "Invalid email or password, please try again.", :unauthorized
        end
      end

      def refresh_token
        refresh_token_value = get_refresh_token_from_cookies
        if refresh_token_value.present? && @current_user.refresh_token == refresh_token_value
          payload = { user_id: @current_user.id }
          new_access_token = JwtService.encode_token payload
          json_response ({ access_token: new_access_token }), :ok
        else
          json_error_response "Unauthorized access", :unauthorized
        end
      end


      private
      def user_params
        params.permit User::USER_PARAMS
      end

      def get_refresh_token_from_cookies
        cookies.encrypted[:refresh_token]
      end
    end
  end
end
