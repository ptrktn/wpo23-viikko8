class User < ApplicationRecord
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships
end
