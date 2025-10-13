class Api::V1::ResumesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_resume, only: [:show]
  before_action :authorize_resume!, only: [:show]

  # userが他人のresumeを閲覧しようとしたら例外発生
  def show
    # クエリパラメータで詳細データの取得を制御
    if params[:include_details] == 'true'
      # 全データ取得
      @resume = Resume.includes(companies: { positions: { tasks: :achievements } }).find(params[:id])
      render json: {
        resume: @resume.as_json(
          include: {
            companies: {
              include: {
                positions: {
                  include: {
                    tasks: {
                      include: :achievements
                    }
                  }
                }
              }
            }
          }
        )
      }
    else
      # 基本情報のみ
      render json: @resume
    end
  end

  def create
    resume = Resume.new(resume_params)
    if resume.save
      render json: resume, status: :created
    else
      render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
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