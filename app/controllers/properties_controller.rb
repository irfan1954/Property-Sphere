class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home index show map]

  before_action :set_property, only: %i[show]

  def home
    @properties = Property.order("RANDOM()").take(10)
  end

  def index
    @properties = Property.all.order(:created_at).reverse_order
  end

  def map
    @properties = Property.all
    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude
      }
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end
end
