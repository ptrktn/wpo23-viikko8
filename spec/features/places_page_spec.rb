require 'rails_helper'

describe "Places" do
  let(:place_name) { 'kumpula' }

  canned_answer = <<~END_OF_STRING
    {"request":{"type":"City","query":"Kumpula, Finland","language":"en","unit":"m"},"location":{"name":"Kumpula","country":"Finland","region":"Lapland","lat":"66.667","lon":"27.583","timezone_id":"Europe/Helsinki","localtime":"2023-10-29 11:10","localtime_epoch":1698577800,"utc_offset":"2.0"},"current":{"observation_time":"09:10 AM","temperature":-12,"weather_code":260,"weather_icons":["https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0007_fog.png"],"weather_descriptions":["Freezing fog"],"wind_speed":4,"wind_degree":106,"wind_dir":"ESE","pressure":1009,"precip":0,"humidity":99,"cloudcover":82,"feelslike":-12,"uv_index":1,"visibility":0,"is_day":"yes"}}
  END_OF_STRING

  before do
    stub_request(:get, /.*kumpula/).to_return(body: canned_answer, headers: { 'Content-Type' => "application/json" })
  end

  it "if no places is returned by the API, notice about is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with(place_name).and_return([])

    visit places_path

    fill_in('city', with: place_name)
    click_button "Search"

    expect(page).to have_content "No locations in #{place_name}"
  end

  it "if one place is returned by the API, it is shown on the page with weather" do
    allow(BeermappingApi).to receive(:places_in).with(place_name).and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path

    fill_in('city', with: place_name)
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "The current beer weather in Kumpula, Finland"
  end

  it "shows all the places returned by API on the page with weather" do
    place_names = %w(Oljenkorsi Hauki Ahven)
    places = place_names.map do |place_name|
      Place.new(name: place_name, id: SecureRandom.rand(99_999))
    end

    allow(BeermappingApi)
      .to receive(:places_in)
      .with(place_name)
      .and_return(places)

    visit places_path

    fill_in('city', with: place_name)
    click_button "Search"

    place_names.each do |place_name|
      expect(page).to have_content place_name
    end

    expect(page).to have_content "The current beer weather in Kumpula, Finland"
  end
end
