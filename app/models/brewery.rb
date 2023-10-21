class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, inclusion: { in: 1040..2022 }

  def to_s
    name.to_s
  end
end
