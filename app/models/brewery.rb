class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def average_rating
    self.ratings.average(:score).to_f
  end

  def to_s
    "#{self.name}"
  end
end
