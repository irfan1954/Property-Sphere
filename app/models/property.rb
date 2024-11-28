class Property < ApplicationRecord
  belongs_to :location

  geocoded_by :property_address
  after_validation :geocode, if: :will_save_change_to_address?

  def property_address
    "#{address}, London, #{location.postcode}"
  end

end
