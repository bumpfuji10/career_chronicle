class Api::V1::ResumesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    resume = Resume.new(resume_params)
    if resume.save
      render json: resume, status: :created
    else
      render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resume_params
    params.require(:resume).permit(:user_id, :summary)
  end
end
