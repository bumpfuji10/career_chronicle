class Api::V1::ResumesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_resume, only: [:show, :update]
  before_action :authorize_resume!, only: [:show, :update]

  # userが他人のresumeを閲覧しようとしたら例外発生
  def show
    @resume = Resume.includes(companies: { positions: { tasks: :achievements } }).find(params[:id])
    render json: { resume: ResumeJsonBuildService.new(resume: @resume).execute }
  end

  def create
    resume = Resume.new(resume_params)
    if resume.save
      render json: resume, status: :created
    else
      render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @resume.update(resume_params)
      render json: @resume, status: :ok
    else
      render json: { errors: @resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_resume
    @resume = Resume.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: '経歴書が見つかりません' }, status: :not_found
  end

  def authorize_resume!
    @user = current_member || current_guest

    unless @user
      return render json: { error: '認証が必要です' }, status: :unauthorized
    end

    unless @resume.user.id == @user.id
      render json: { error: 'この経歴書を閲覧する権限がありません' }, status: :forbidden
    end
  end

  def resume_params
    params.require(:resume).permit(:user_id, :summary)
  end
end