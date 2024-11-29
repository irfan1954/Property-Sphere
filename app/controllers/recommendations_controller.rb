class RecommendationsController < ApplicationController
  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user_id = current_user.id
    recommendation_postcode = postcode_params[:postcode].gsub(/\s+/, "").upcase
    @recommendation.location_id = Location.find_by(postcode: recommendation_postcode).id

    if @recommendation.save
      redirect_to root_path, notice: 'Recommendation was successfully created.'
    else
      render :new
    end
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(
      :comment
    )
  end

  def postcode_params
    params.require(:recommendation).permit(
      :postcode
    )
  end

end
