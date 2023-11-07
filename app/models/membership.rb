class Membership < ApplicationRecord
  belongs_to :beer_club
  belongs_to :user

  scope :confirmed, -> { where confirmed: true }

  validates :beer_club_id, uniqueness: {
    scope: :user_id,
    message: "User can join a given club only once"
  }
end
