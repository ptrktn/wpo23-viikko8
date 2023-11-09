class Style < ApplicationRecord
  extend TopMethod

  has_many :beers, dependent: :destroy

  def to_s
    name
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
    ActiveRecord::Base.connection.execute(sql).to_a.first['average']
  end
end
