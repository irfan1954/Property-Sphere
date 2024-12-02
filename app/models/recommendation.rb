class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :location

  # REGEX for user recommendation postcode to match database
  validates :comment, presence: true, length: { minimum: 10 }

end
