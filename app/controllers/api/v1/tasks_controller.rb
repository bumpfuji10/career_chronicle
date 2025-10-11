module Api
  module V1
    class TasksController < BaseController
      before_action :set_career_profile
      before_action :set_work_experience
      before_action :set_task, only: [:update, :destroy]

      def create
        task = @work_experience.tasks.build(task_params)

        if task.save
          render json: { success: true, task: serialize_task(task) }, status: :created
        else
          render_validation_error(task)
        end
      end

      def update
        if @task.update(task_params)
          render json: { success: true, task: serialize_task(@task) }, status: :ok
        else
          render_validation_error(@task)
        end
      end

      def destroy
        @task.destroy
        render json: { success: true }, status: :ok
      end

      private

      def set_career_profile
        @career_profile = api_current_user.career_profiles.find(params[:career_profile_id])
      end

      def set_work_experience
        @work_experience = @career_profile.work_experiences.find(params[:work_experience_id])
      end

      def set_task
        @task = @work_experience.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:content, :display_order)
      end
    end
  end
end
