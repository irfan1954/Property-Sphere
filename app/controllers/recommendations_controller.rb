class RecommendationsController < ApplicationController
  def New
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    @property.save!
  end

  private

  def property_params
    params.require(:property).permit(
      :street_address,
      :postcode,
      :description,
      :bedrooms,
      :bathrooms,
      :garden,
      :image_urls,
      :council_tax,
      :type,
      :floor_area,
    )
  end
end
