class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home index show map]

  before_action :set_property, only: %i[show]

  def home
    @properties = Property.order("RANDOM()").take(10)
  end

  def index
    @properties = Property.all
    if params[:min_price].present? && params[:min_price] != "Min"
      @properties = Property.where("price > ?", params[:min_price])
    end
    if params[:max_price].present? && params[:max_price] != "Max"
      @properties = Property.where("price < ?", params[:max_price])
    end
    if params[:min_bedrooms].present? && params[:min_bedrooms] != "Min"
      @properties = Property.where("bedrooms > ?", params[:min_bedrooms])
    end
    if params[:min_bathrooms].present? && params[:min_bathrooms] != "Min"
      @properties = Property.where("bathrooms > ?", params[:min_bathrooms])
    end
    if params[:property_type].present? && params[:property_type] != "Type"
      @properties = Property.where("property_type = ?", params[:property_type])
    end
    if params[:floor_area].present? && params[:floor_area] != "Min sqm"
      @properties = Property.where("floor_area > ?", params[:floor_area])
    end
  end

  def map
    @properties = Property.all
    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { property: property }),
        marker_html: render_to_string(partial: "marker", icon: nil),
        property_path: property_path(property)
      }
    end
  end

  def show
    if @property.geocoded?
      @markers = [{
          lat: @property.latitude,
          lng: @property.longitude,
          marker_html: render_to_string(partial: "marker", locals: { icon: nil })
        }]
    else
        @markers = [{}]
    end
    @amenities = Amenity.geocoded.near([@property.latitude, @property.longitude], 10)
    @amenities.map do |amenity|
      @markers << { lat: amenity.lat,
        lng: amenity.long,
        marker_html: render_to_string(partial: "marker", locals: { icon: amenity.icon }),
        info_window_html: render_to_string(partial: "amenity_info_window", locals: { amenity: amenity })
      }
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end
end
