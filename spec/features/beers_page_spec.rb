require 'rails_helper'

describe "Rating" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style, name: 'Lager' }

  before :each do
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "creates a new beer when a name is given" do
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    select('Lager', from: 'beer[style_id]')
    fill_in('beer[name]', with: 'I')

    expect{
      click_button "Create Beer"
    }.to change{ Beer.count }.from(0).to(1)
  end

  it "does not create a beer when the name is left blank" do
    visit new_beer_path

    select('Koff', from: 'beer[brewery_id]')
    select('Lager', from: 'beer[style_id]')

    expect { click_button "Create Beer" }.not_to(change { Beer.count })

    expect(page).to have_content "Name can't be blank"
  end
end
