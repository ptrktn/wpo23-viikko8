class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, presence: true,
                   numericality: {
                     only_integer: true,
                     greater_than_or_equal_to: 1040
                   }
  validate :year_not_in_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def to_s
    name.to_s
  end

  def year_not_in_future
    errors.add(:year, "brewery year is in future") if year > Date.current.year
  end

  def self.top(limit = 3)
    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select id from ( ' \
        'select breweries.id as id, avg(ratings.score) as average from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'inner join breweries on beers.brewery_id = breweries.id ' \
        'group by 1 order by 2 desc limit :limit) x', { limit: }
      ]
    )
    ActiveRecord::Base.connection.execute(sql).flatten.to_a.map { |k| Brewery.find k['id'] }
  end
end
