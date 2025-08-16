module Api
  module V1
    class ResumesController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :ensure_user, only: [:create]

      def create
        resume = @user.resumes.build(resume_params)
        resume.summary = resume.generate_summary
        if resume.save
          render json: { id: resume.id, summary: resume.summary }, status: :created
        else
          render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def ensure_user
        @user = current_member || ProvideGuestUser.new(session).call
      end

      def resume_params
        params.require(:resume).permit(:company, :position, :tasks, :improvements, :achievements)
      end
    end
  end
end