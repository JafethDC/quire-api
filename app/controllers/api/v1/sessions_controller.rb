module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_with_token, only: [:destroy]

      def create
        fb_profile = validate_fb_user(params[:fb_access_token])
        user = User.find_by_email(fb_profile[:email])
        if user
          if user.access_token.nil?
            user.update_attributes(update_params)
            render json: user, status: 200
          else
            render json: { errors: ['Session already exists'] }, status: 422
          end
        else
          user = User.new(create_params(fb_profile))
          if user.save
            render json: user, status: 201
          else
            render json: { errors: user.errors.full_messages }, status: 422
          end
        end
      end

      def destroy
        if logged_user.update_attributes(access_token: nil)
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def create_params(fb_profile)
        user_params.merge(access_token: generate_api_token, email: fb_profile[:email],
                          name: fb_profile[:name], fb_user_id: fb_profile[:id])
      end

      def update_params
        { access_token: generate_api_token, last_location: user_params[:last_location] }
      end

      def user_params
        params.require(:user).permit(:last_location)
      end
    end
  end
end

