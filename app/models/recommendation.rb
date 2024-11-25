class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :postcode

  # REGEX for user recommendation postcode to match database

end
