class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home index show map search]

  before_action :set_property, only: %i[show]

  require "csv"

  def home
    @postcodes_for_search = Location.all_postcodes
    @properties = Property.order("RANDOM()").take(10)
  end

  def index
    @postcodes_for_search = Location.all_postcodes

    if params[:postcode].present?
      postcode = Location.find_by(raw_postcode: params[:postcode])
      location_ids = Location.geocoded.near([postcode.lat, postcode.long], 5.0).map { |loc| loc.id}
      @locations = Location.where(id: location_ids)
    else
      @locations = Location.all
    end
    if params[:property].present?
      @locations = @locations.where('rent_price > ?', 24000)
    end
    if params[:neighbourhood].present?
      @locations = @locations.where('crime < ?', 350)
    end
    # if params[:property].present?
      # @locations = @locations.where('rent_price > ?', 2000)
    # end

    # @properties = Property.all.order(:created_at).reverse_order
    @properties = Property.where(location_id: @locations.pluck(:id))

    if params[:min_price].present? && params[:min_price] != "Min"
      @properties = @properties.where("price > ?", params[:min_price])
    end
    if params[:max_price].present? && params[:max_price] != "Max"
      @properties = @properties.where("price < ?", params[:max_price])
    end
    if params[:min_bedrooms].present? && params[:min_bedrooms] != "Min"
      @properties = @properties.where("bedrooms > ?", params[:min_bedrooms])
    end
    if params[:min_bathrooms].present? && params[:min_bathrooms] != "Min"
      @properties = @properties.where("bathrooms > ?", params[:min_bathrooms])
    end
    if params[:property_type].present? && params[:property_type] != "Type"
      @properties = @properties.where("property_type = ?", params[:property_type])
    end
    if params[:floor_area].present? && params[:floor_area] != "Min sqm"
      @properties = @properties.where("floor_area > ?", params[:floor_area])
    end

    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { property: property }),

        marker_html: render_to_string(partial: "marker", locals: { icon: nil }),

        property_path: property_path(property)
      }
    end

    @recommended_properties = Property.order("RANDOM()").take(10)

    @data = { "properties" => @properties, "recommended_properties" => @recommended_properties  }
  end

  def search
    @postcodes_for_search = Location.all_postcodes
    search_param = params[:postcode].present? ? params[:postcode] : "W10 4AD"

    postcode = Location.find_by(raw_postcode: search_param)

    puts postcode

    nearby_location_ids = Location.geocoded.near([postcode.lat, postcode.long], 5.0).map { |loc| loc.id}

    @properties = Property.where(location_id: nearby_location_ids)

    # recommendations_location_ids = Recommendation.order("RANDOM()").take(10).map { |recommendation| recommendation.location_id}

    # @recommended_properties = Property.where(location_id: recommendations_location_ids)

    @recommended_properties = Property.order("RANDOM()").take(10)

    @data = { "properties" => @properties, "recommended_properties" => @recommended_properties }

    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { property: property }),

        marker_html: render_to_string(partial: "marker", locals: { icon: nil }),

        property_path: property_path(property)
      }
    end

    render :index
  end

  def map
    @properties = Property.all
    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { property: property }),

        marker_html: render_to_string(partial: "marker", locals: { icon: nil }),

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

    @closest_supmarket = @amenities.where(category: "supermarket").first
    @closest_hospital = @amenities.where(category: "hospital").first
    @closest_pharmacy = @amenities.where(category: "pharmacy").first
    @closest_primary = @amenities.where(category: "primary_school").first
    @closest_secondary = @amenities.where(category: "secondary_school").first

    @demo = {}
    CSV.foreach("lib/files/portrait_classifications_2011.csv", headers: true) do |row|
      @demo[row["subgroup_code"].to_s] = row["subgroup"]
    end

    @amenities.map do |amenity|
      @markers << { lat: amenity.lat,
        lng: amenity.long,
        marker_html: render_to_string(partial: "marker", locals: { icon: amenity.icon }),
        info_window_html: render_to_string(partial: "amenity_info_window", locals: { amenity: amenity })
      }
    end
    @house_sqm_price = house_sqm_price(@property)

    nearby_location_ids = Location.geocoded.near([@property.latitude, @property.longitude], 1.0).map { |loc| loc.id}
    nearby_properties = Property.where(location_id: nearby_location_ids)

    if nearby_properties.count > 3
      @avg_price_nearby = nearest_avg_price(@property)
      @avg_sqm_price = nearest_avg_sqm_price(@property)
      @house_sqm_value = house_sqm_value_nearby(@property, @avg_sqm_price)
    else
      @avg_price_nearby = london_avg_price
      @avg_sqm_price = london_avg_sqm_price
      @house_sqm_value = house_sqm_value_london(@property)
    end

    @property_yield = property_yield(@property)
    @properties_average_yield = london_avg_bedroom_yield
    @total_rent = total_rent(@property)

    if current_user.saved_properties.find_by(property_id: @property.id).nil?
      @bookmark = SavedProperty.new
    else
      @bookmark = current_user.saved_properties.find_by(property_id: @property.id)
    end
  end

  def postcodes
    @postcodes = fetch_postcodes
  end

  private

  def house_sqm_value_nearby(property, avg_sqm_price)
    return (((house_sqm_price(property).to_f / avg_sqm_price) * 100).round(2) - 100).round(2)
  end

  def house_sqm_value_london(property)
    return (((house_sqm_price(property).to_f / london_avg_sqm_price) * 100).round(2) - 100).round(2)
  end

  def house_sqm_price(property)
    return (property.price / property.floor_area.to_f).round
  end

  def nearest_avg_sqm_price(property)
    return (nearest_avg_price(property) / nearest_avg_sqm(property)).round
  end

  def london_avg_sqm_price
    return (london_avg_price / london_avg_sqm).round
  end

  def london_avg_price
    Property.all.pluck(:price).sum.to_f / Property.count
  end

  def london_avg_sqm
    Property.all.pluck(:floor_area).sum.to_f / Property.count
  end

  def nearest_avg_price(property)
    nearby_location_ids = Location.geocoded.near([property.latitude, property.longitude], 1.0).map { |loc| loc.id}
    nearby_property_prices = Property.where(location_id: nearby_location_ids).pluck(:price)
    return (nearby_property_prices.sum.to_f / nearby_property_prices.count).round(2)
  end

  def nearest_avg_sqm(property)
    nearby_location_ids = Location.geocoded.near([property.latitude, property.longitude], 1.0).map { |loc| loc.id}
    nearby_property_floor_area = Property.where(location_id: nearby_location_ids).pluck(:floor_area)
    return (nearby_property_floor_area.sum.to_f / nearby_property_floor_area.count).round(2)
  end

  def property_yield(property)
    (((property.location.rent_price.to_f * property.bedrooms) / property.price) * 100).round(2)
  end

  # I need to figure out the average £/bedroom
  # Divide that price by the london average rent to figure out the yield.

  def london_avg_bedroom_rent
    Location.all.pluck(:rent_price).sum.to_f / Location.count
  end

  def london_avg_price_per_room
    (Property.all.pluck(:price).sum / Property.all.pluck(:bedrooms).sum.to_f)
  end

  def total_rent(property)
    (property.bedrooms * property.location.rent_price)
  end

  def london_avg_bedroom_yield
    ((london_avg_bedroom_rent / london_avg_price_per_room) * 100).round(2)
  end

  def set_property
    @property = Property.find(params[:id])
  end
end
