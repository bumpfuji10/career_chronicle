class ResumesController < ApplicationController
  protect_from_forgery with: :null_session

  def new
  end

  def create
    resume = Resume.new(resume_params)
    resume.summary = generate_summary(resume)
    if resume.save
      render json: { id: resume.id, summary: resume.summary }, status: :created
    else
      render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def resume_params
    params.require(:resume).permit(:company, :position, :tasks, :improvements, :achievements)
  end

  def generate_summary(resume)
    "私は#{resume.company}で#{resume.position}として、#{resume.tasks}。その中で#{resume.improvements}。結果として#{resume.achievements}。"
  end
end
