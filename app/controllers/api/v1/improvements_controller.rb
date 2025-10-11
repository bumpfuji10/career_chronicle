module Api
  module V1
    class ImprovementsController < BaseController
      before_action :set_career_profile
      before_action :set_work_experience
      before_action :set_improvement, only: [:update, :destroy]

      def create
        improvement = @work_experience.improvements.build(improvement_params)

        if improvement.save
          render json: { success: true, improvement: serialize_improvement(improvement) }, status: :created
        else
          render_validation_error(improvement)
        end
      end

      def update
        if @improvement.update(improvement_params)
          render json: { success: true, improvement: serialize_improvement(@improvement) }, status: :ok
        else
          render_validation_error(@improvement)
        end
      end

      def destroy
        @improvement.destroy
        render json: { success: true }, status: :ok
      end

      private

      def set_career_profile
        @career_profile = api_current_user.career_profiles.find(params[:career_profile_id])
      end

      def set_work_experience
        @work_experience = @career_profile.work_experiences.find(params[:work_experience_id])
      end

      def set_improvement
        @improvement = @work_experience.improvements.find(params[:id])
      end

      def improvement_params
        params.require(:improvement).permit(:content, :display_order)
      end
    end
  end
end
