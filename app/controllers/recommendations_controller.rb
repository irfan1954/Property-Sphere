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
    # rec_postcode = @recommendation.location.postcode.split.strip.join.upcase
    # pcds transformation in database
    # data_postcode = Location.find(pcds: rec_postcode)
    # @recommendation.location_id = data_postcode.id
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
end
