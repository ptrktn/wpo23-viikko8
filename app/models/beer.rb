class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    name
  end

  def self.top(limit = 3)
    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select id from ( ' \
        'select beers.id as id, avg(ratings.score) as average from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'group by 1 order by 2 desc limit :limit) x', { limit: }
      ]
    )
    ActiveRecord::Base.connection.execute(sql).to_a.map { |k| Beer.find k['id'] }
  end
end
