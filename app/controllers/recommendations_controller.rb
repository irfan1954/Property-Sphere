class RecommendationsController < ApplicationController
  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user_id = current_user.id
    postcode = Postcode.find(postcode: @recommendation.postcode)
    @recommendation.postcode_id = postcode.id
    @recommendation.save!
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(
      :postcode,
      :comment
    )
  end
end
