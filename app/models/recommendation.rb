class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :location

  # REGEX for user recommendation postcode to match database

end
