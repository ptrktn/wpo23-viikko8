class Brewery < ApplicationRecord
  extend TopMethod
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, presence: true,
                   numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: 1040
                   }
  validate :year_not_in_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def to_s
    name.to_s
  end

  def year_not_in_future
    errors.add(:year, "brewery year is in future") if year > Date.current.year
  end

  def number_of_beers
    beers.count
  end

  after_create_commit do
    target_id =
      if active
        "active_brewery_rows"
      else
        "retired_brewery_rows"
      end

    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id
  end
end
