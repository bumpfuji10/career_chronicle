class ResumesController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :find_or_create_guest_user, only: [:new, :create]

  def new
    @resume = Resume.new
    respond_to do |format|
      format.html
      format.json { render json: { guest_user_id: @guest_user.id } }
    end
  end

  def create
    resume = @guest_user.resumes.build(resume_params)
    resume.summary = generate_summary(resume)
    if resume.save
      render json: { id: resume.id, summary: resume.summary }, status: :created
    else
      render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_or_create_guest_user
    if session[:guest_user_token]
      @guest_user = GuestUser.find_by(session_token: session[:guest_user_token])
    end
    
    unless @guest_user
      session_token = SecureRandom.hex(16)
      @guest_user = GuestUser.create!(session_token: session_token)
      session[:guest_user_token] = session_token
    end
  end

  def resume_params
    params.require(:resume).permit(:company, :position, :tasks, :improvements, :achievements)
  end

  def generate_summary(resume)
    "私は#{resume.company}で#{resume.position}として、#{resume.tasks}。その中で#{resume.improvements}。結果として#{resume.achievements}。"
  end
end
