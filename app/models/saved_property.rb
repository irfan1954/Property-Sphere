class SavedProperty < ApplicationRecord
  attr_accessor :message
  belongs_to :user
  belongs_to :property

  validates :property_id, presence: true
  validates :property_id, uniqueness: true
  validates :user_id, presence: true
end
