class ResumesController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :ensure_user, only: [:new, :create]

  def new
    @resume = @current_user.resumes.build
  end

  def create
    @resume = @current_user.resumes.build(resume_params)
    if @resume.save
      redirect_to @resume, notice: '履歴書が作成されました。'
    else
      render :new
    end
  end

  private

  def ensure_user
    @current_user = current_user || ProvideGuestUser.new(session).call
  end

  def resume_params
    params.require(:resume).permit(:company, :position, :tasks, :improvements, :achievements)
  end
end
