class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy

  def to_s
    "#{self.name}"
  end
end
