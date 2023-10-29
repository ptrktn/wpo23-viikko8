class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("weather-#{city}", expires_in: 7.days) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    response = HTTParty.get url(city)
    response.parsed_response.with_indifferent_access
  end

  def self.url(city)
    "http://api.weatherstack.com/current?access_key=#{key}&units=m&query=#{ERB::Util.url_encode(city)}"
  end

  def self.key
    return nil if Rails.env.test?

    raise 'WEATHERSTACK_API_KEY env variable not defined' if ENV['WEATHERSTACK_API_KEY'].nil?

    ENV.fetch('WEATHERSTACK_API_KEY')
  end
end
