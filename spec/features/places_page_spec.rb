require 'rails_helper'

describe "Places" do
  let(:place_name) { 'kumpula' }

  it "if no places is returned by the API, notice about is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with(place_name).and_return([])

    visit places_path

    fill_in('city', with: place_name)
    click_button "Search"

    expect(page).to have_content "No locations in #{place_name}"
  end

  it "if one place is returned by the API, it is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with(place_name).and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path

    fill_in('city', with: place_name)
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "shows all the places returned by API on the page" do
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
  end
end
