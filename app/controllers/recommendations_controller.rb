class RecommendationsController < ApplicationController
  def new
    @recommendation = Recommendation.new
  end

  def index
    @recommendations = Recommendation.all
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user_id = current_user.id
    recommendation_postcode = postcode_params[:postcode].gsub(/\s+/, "").upcase
    unless Location.find_by(postcode: recommendation_postcode).nil?
      @recommendation.location_id = Location.find_by(postcode: recommendation_postcode).id
    end

    if @recommendation.save
      redirect_to recommendations_path, notice: 'Recommendation was successfully created.'
    else
      render :new
    end
  end

  def show
    @recommendation = Recommendation.find(recommendation_params[:location_id])
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy
    redirect_to recommendations_path, notice: "Recommendation deleted."
  end


  private

  def recommendation_params
    params.require(:recommendation).permit(
      :comment, :location_id
    )
  end

  def postcode_params
    params.require(:recommendation).permit(
      :postcode
    )
  end

end
