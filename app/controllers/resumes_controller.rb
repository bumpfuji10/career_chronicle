class ResumesController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  before_action :find_or_create_guest_user, only: [:new]

  def new
    @resume = Resume.new
  end

  private

  def find_or_create_guest_user
    @guest_user = ProvideGuestUser.new(session).call
  end

  def resume_params
    params.require(:resume).permit(:company, :position, :tasks, :improvements, :achievements)
  end
end
