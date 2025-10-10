module Api
  module V1
    class CareerProfilesController < BaseController
      def create
        if api_current_user.is_a?(Guest) && api_current_user.career_profiles.exists?
          return render_forbidden_response('ゲストユーザーはキャリアプロフィールを1件までしか作成できません')
        end

        career_profile = api_current_user.career_profiles.build(career_profile_params)

        if career_profile.save
          render json: { success: true, career_profile: serialize_career_profile(career_profile) }, status: :created
        else
          render_validation_error(career_profile)
        end
      end

      def show
        career_profile = api_current_user.career_profiles.find(params[:id])
        render json: { success: true, career_profile: serialize_career_profile(career_profile) }, status: :ok
      end

      private

      def career_profile_params
        params.fetch(:career_profile, {}).permit(:title)
      end
    end
  end
end
