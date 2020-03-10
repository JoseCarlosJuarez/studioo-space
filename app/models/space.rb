class Space < ApplicationRecord
  has_one_attached :photo

  has_many :reservations, dependent: :destroy
  has_many :reviews, through: :reservations
  has_many :space_tags, :reservations, dependent: :destroy

  belongs_to :user

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, :address, :price_per_day, :city, :content, presence: true
  monetize :price_per_day
  def full_address
    "#{address} - #{city}"
  end

  def booked_by?(user)
    reservations.any? do |reservation|
      reservation.user == user
    end
  end
end
