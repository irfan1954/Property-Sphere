class Location < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :amenities
  has_many :recommendations

end
