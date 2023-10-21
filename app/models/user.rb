class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password,
            length: { minimum: 4 }
  validate :password_special_characters

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_special_characters
    errors.add(:password, 'must contain at least one uppercase character') unless password.match(/[A-Z]+/)
    errors.add(:password, 'must contain at least one digit') unless password.match(/\d+/)
  end
end
