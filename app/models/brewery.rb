class Brewery < ApplicationRecord
  has_many :beers

  def to_s
    "#{self.name}"
  end
end
