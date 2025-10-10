module Api
  module V1
    class WorkExperiencesController < BaseController
      before_action :set_career_profile
      before_action :set_work_experience, only: [:show, :update, :generate_summary]

      def create
        work_experience = @career_profile.work_experiences.build(work_experience_params)

        if work_experience.save
          render json: { success: true, work_experience: serialize_work_experience(work_experience) }, status: :created
        else
          render_validation_error(work_experience)
        end
      end

      def show
        render json: { success: true, work_experience: serialize_work_experience(@work_experience) }, status: :ok
      end

      def update
        if @work_experience.update(work_experience_params)
          render json: { success: true, work_experience: serialize_work_experience(@work_experience) }, status: :ok
        else
          render_validation_error(@work_experience)
        end
      end

      def generate_summary
        summary_text = @work_experience.generate_summary
        experience_summary = @work_experience.experience_summary || @work_experience.build_experience_summary
        experience_summary.content = summary_text

        if experience_summary.save
          render json: { success: true, summary: experience_summary.content }, status: :ok
        else
          render_validation_error(experience_summary)
        end
      end

      private

      def set_career_profile
        @career_profile = api_current_user.career_profiles.find(params[:career_profile_id])
      end

      def set_work_experience
        @work_experience = @career_profile.work_experiences.find(params[:id])
      end

      def work_experience_params
        params.require(:work_experience).permit(:company, :position, :start_at, :end_at, :is_current, :display_order)
      end
    end
  end
end
