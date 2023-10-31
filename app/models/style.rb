class Style < ApplicationRecord
  has_many :beers, dependent: :destroy

  def to_s
    name
  end

  def self.top(limit = 3)
    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select id from ( ' \
        'select styles.id as id, avg(ratings.score) as average from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'inner join styles on beers.style_id = styles.id ' \
        'group by 1 order by 2 desc limit :limit) x', { limit: }
      ]
    )
    ActiveRecord::Base.connection.execute(sql).flatten.to_a.map { |k| Style.find k['id'] }
  end

  def average_rating
    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select avg(score) as average from ( ' \
        'select ratings.score as score from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'inner join styles on beers.style_id = styles.id ' \
        'where styles.id = :style_id) x', { style_id: id }
      ]
    )
    ActiveRecord::Base.connection.execute(sql).flatten.to_a.first['average']
  end
end
