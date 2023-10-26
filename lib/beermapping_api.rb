class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    places = Rails.cache.fetch(city, expires_in: 7.days) { get_places_in(city) }

    places.each do |place|
      Rails.cache.write(place.id.to_s, place)
    end

    places
  end

  def self.place(bm_id)
    Rails.cache.fetch(bm_id, expires_in: 7.days) { get_place(bm_id) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.get_place(bm_id)
    response = HTTParty.get "http://beermapping.com/webservice/locquery/#{key}/#{bm_id}"
    place = response.parsed_response["bmp_locations"]["location"]

    return nil if place.is_a?(Hash) && place['id'].nil?

    Place.new(place)
  end

  def self.key
    return nil if Rails.env.test?

    raise 'BEERMAPPING_API_KEY env variable not defined' if ENV['BEERMAPPING_API_KEY'].nil?

    ENV.fetch('BEERMAPPING_API_KEY')
  end
end
