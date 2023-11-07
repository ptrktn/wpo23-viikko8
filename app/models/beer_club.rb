class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :members, through: :memberships, source: :user do
    def confirmed
      where("memberships.confirmed = ?", true)
    end
  end

  def to_s
    name
  end
end
