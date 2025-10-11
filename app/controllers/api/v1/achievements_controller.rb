module Api
  module V1
    class AchievementsController < BaseController
      before_action :set_career_profile
      before_action :set_work_experience
      before_action :set_achievement, only: [:update, :destroy]

      def create
        achievement = @work_experience.achievements.build(achievement_params)

        if achievement.save
          render json: { success: true, achievement: serialize_achievement(achievement) }, status: :created
        else
          render_validation_error(achievement)
        end
      end

      def update
        if @achievement.update(achievement_params)
          render json: { success: true, achievement: serialize_achievement(@achievement) }, status: :ok
        else
          render_validation_error(@achievement)
        end
      end

      def destroy
        @achievement.destroy
        render json: { success: true }, status: :ok
      end

      private

      def set_career_profile
        @career_profile = api_current_user.career_profiles.find(params[:career_profile_id])
      end

      def set_work_experience
        @work_experience = @career_profile.work_experiences.find(params[:work_experience_id])
      end

      def set_achievement
        @achievement = @work_experience.achievements.find(params[:id])
      end

      def achievement_params
        params.require(:achievement).permit(:content, :display_order)
      end
    end
  end
end
