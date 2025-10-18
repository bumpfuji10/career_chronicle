class Api::V1::CompaniesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    company = Company.new(company_params)
    if company.save
      render json: company, status: :created
    else
      render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    company = Company.find(params[:id])
    if company.update(company_params)
      head :no_content
    else
      render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:resume_id, :name, :industry, :started_at, :ended_at)
  end
end