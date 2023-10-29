class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{brewery.name} #{name}"
  end
end
