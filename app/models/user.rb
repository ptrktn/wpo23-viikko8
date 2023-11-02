class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password,
            length: { minimum: 4 }
  validate :password_special_characters

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def password_special_characters
    errors.add(:password, 'must contain at least one uppercase character') unless password&.match(/[A-Z]+/)
    errors.add(:password, 'must contain at least one digit') unless password&.match(/\d+/)
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select name from styles where id = (select style_id from ( ' \
        'select beers.style_id as style_id, avg(ratings.score) as avg_rating from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'where ratings.user_id = :user_id ' \
        'group by 1 order by 2 desc limit 1) x )', { user_id: id }
      ]
    )
    result = ActiveRecord::Base.connection.execute(sql).first.flatten.to_a
    result[1]
  end

  def favorite_brewery
    return nil if ratings.empty?

    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select name from breweries where id = (select brewery_id from ( ' \
        'select beers.brewery_id as brewery_id, avg(ratings.score) as avg_rating from ratings ' \
        'inner join beers on ratings.beer_id = beers.id ' \
        'where ratings.user_id = :user_id ' \
        'group by 1 order by 2 desc limit 1) x)', { user_id: id }
      ]
    )
    result = ActiveRecord::Base.connection.execute(sql).first.flatten.to_a
    result[1]
  end

  def self.top(limit = 3)
    sql = ActiveRecord::Base.sanitize_sql_for_conditions(
      [
        'select id from ( ' \
        'select users.id as id, count(*) as ratings from ratings ' \
        'inner join users on ratings.user_id = users.id ' \
        'group by 1 order by 2 desc limit :limit) x', { limit: }
      ]
    )
    ActiveRecord::Base.connection.execute(sql).to_a.map { |k| User.find k['id'] }
  end
end
