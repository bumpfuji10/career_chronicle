class Api::V1::PositionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    position = Position.new(position_params)
    if position.save
      render json: position, status: :created
    else
      render json: { errors: position.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    position = Position.find(params[:id])
    if position.update(position_params)
      head :no_content
    else
      render json: { errors: position.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def position_params
    params.require(:position).permit(:company_id, :title, :started_at, :ended_at)
  end
end
