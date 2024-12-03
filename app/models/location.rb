class Location < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :amenities
  has_many :recommendations

  geocoded_by :raw_postcode
  reverse_geocoded_by :lat, :long

  def self.all_postcodes
    all.pluck(:raw_postcode)
  end
end
