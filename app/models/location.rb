class Location < ApplicationRecord
  has_many :properties
  has_many :amenities
  has_many :recommendations

end
