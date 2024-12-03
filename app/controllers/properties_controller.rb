class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home index show map search]

  before_action :set_property, only: %i[show]

  def home
    @postcodes = Location.all_postcodes
    @properties = Property.order("RANDOM()").take(10)
  end

  def index
    @postcodes = Location.all_postcodes
    @properties = Property.all.order(:created_at).reverse_order
  end

  def search
    postcode = Location.find_by(raw_postcode: params[:postcode])

    nearby_location_ids = Location.geocoded.near([postcode.lat, postcode.long], 0.5).map { |loc| loc.id}

    @properties = Property.where(location_id: nearby_location_ids)

    # recommendations_location_ids = Recommendation.order("RANDOM()").take(10).map { |recommendation| recommendation.location_id}

    # @recommended_properties = Property.where(location_id: recommendations_location_ids)

    @recommended_properties = Property.order("RANDOM()").take(10)

    @data = { "properties" => @properties, "recommended_properties" => @recommended_properties }

    render :index
  end

  def map
    @properties = Property.all
    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { property: property }),
        marker_html: render_to_string(partial: "marker"),
        property_path: property_path(property)
      }
    end
  end

  def show
    @marker =
      {
        lat: @property.latitude,
        lng: @property.longitude,
        marker_html: render_to_string(partial: "marker")
      }
  end

  def postcodes
    @postcodes = fetch_postcodes
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end
end
