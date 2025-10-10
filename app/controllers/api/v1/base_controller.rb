module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :ensure_user

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

      private

      attr_reader :api_current_user

      def ensure_user
        @api_current_user = current_member || current_guest
        return if @api_current_user

        render json: { success: false, errors: ['認証が必要です'] }, status: :unauthorized
      end

      def render_not_found_response
        render json: { success: false, errors: ['リソースが見つかりません'] }, status: :not_found
      end

      def render_forbidden_response(message)
        render json: { success: false, errors: [message] }, status: :forbidden
      end

      def render_validation_error(resource)
        render json: { success: false, errors: resource.errors.full_messages }, status: :unprocessable_entity
      end

      def serialize_task(task)
        {
          id: task.id,
          content: task.content,
          display_order: task.display_order
        }
      end

      def serialize_improvement(improvement)
        {
          id: improvement.id,
          content: improvement.content,
          display_order: improvement.display_order
        }
      end

      def serialize_achievement(achievement)
        {
          id: achievement.id,
          content: achievement.content,
          display_order: achievement.display_order
        }
      end

      def serialize_work_experience(work_experience)
        {
          id: work_experience.id,
          company: work_experience.company,
          position: work_experience.position,
          start_at: work_experience.start_at,
          end_at: work_experience.end_at,
          is_current: work_experience.is_current,
          display_order: work_experience.display_order,
          tasks: work_experience.tasks.order(:display_order, :id).map { |task| serialize_task(task) },
          improvements: work_experience.improvements.order(:display_order, :id).map { |improvement| serialize_improvement(improvement) },
          achievements: work_experience.achievements.order(:display_order, :id).map { |achievement| serialize_achievement(achievement) },
          experience_summary: work_experience.experience_summary&.content
        }
      end

      def serialize_career_profile(career_profile)
        {
          id: career_profile.id,
          title: career_profile.title,
          work_experiences: career_profile.work_experiences.order(:display_order, :id).map { |work_experience| serialize_work_experience(work_experience) }
        }
      end
    end
  end
end
