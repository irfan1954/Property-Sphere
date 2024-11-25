class RecommendationsController < ApplicationController
  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user_id = current_user.id
    rec_postcode = @recommendation.postcode.split.strip.join.upcase
    # pcds transformation in database
    data_postcode = Postcode.find(pcds: rec_postcode)
    @recommendation.postcode_id = data_postcode.id
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
