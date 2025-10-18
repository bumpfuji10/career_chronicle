class Api::V1::AchievementsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    achievement = Achievement.new(achievement_params)
    if achievement.save
      render json: achievement, status: :created
    else
      render json: { errors: achievement.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    achievement = Achievement.find(params[:id])
    if achievement.update(achievement_params)
      head :no_content
    else
      render json: { errors: achievement.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def achievement_params
    params.require(:achievement).permit(:task_id, :content)
  end
end
