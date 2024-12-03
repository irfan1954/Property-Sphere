class Amenity < ApplicationRecord
  geocoded_by :name, latitude: :lat, longitude: :long

  def icon
    case category
    when "hospital"
      '<i class="fa-solid fa-hospital"></i>'.html_safe
    when "pharmacy"
      '<i class="fa-solid fa-mortar-pestle"></i>'.html_safe
    when "supermarket"
      '<i class="fa-solid fa-basket-shopping"></i>'.html_safe
    when "primary_school"
      '<i class="fa-solid fa-school"></i>'.html_safe
    when "secondary_school"
      '<i class="fa-solid fa-school"></i>'.html_safe
    when "subway_station"
      '<i class="fa-solid fa-train-subway"></i>'.html_safe
    when "train_station"
      '<i class="fa-solid fa-train"></i>'.html_safe
    else
      '<i class="fa-solid fa-circle-dot"></i>'.html_safe
    end
  end
end
