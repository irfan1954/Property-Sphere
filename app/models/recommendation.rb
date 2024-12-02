class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :location

  # REGEX for user recommendation postcode to match database

  # validates :postcode, presence: true
  validates :comment, presence: true, length: { minimum: 10 }

end
