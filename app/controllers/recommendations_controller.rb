class RecommendationsController < ApplicationController
  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(property_params)
    @recommendation.save!
  end

  private

  def property_params
    params.require(:recommendation).permit(
      :postcode,
      :comment,
      :user_id,
      :postcode_id
    )
  end
end
