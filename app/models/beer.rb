class Beer < ApplicationRecord
  extend TopMethod
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    name
  end
end
