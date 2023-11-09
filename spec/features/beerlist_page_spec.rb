require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
      )
    end

    Capybara.javascript_driver = :chrome

    # Avoid issues due to Chrome checking for updates
    WebMock.allow_net_connect!

    # TODO: net access should be disabled less localhost
    # WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  it "shows one known beer", js: true do
    visit beerlist_path

    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js: true do
    visit beerlist_path

    names = []

    find('#beertable').all('.tablerow').each do |tr|
      names.append(tr.all('td').map(&:text).first)
    end

    expect(names).to eq(["Fastenbier", "Lechte Weisse", "Nikolai"])
  end

  it 'sorts beer list by style', js: true do
    visit beerlist_path

    within('#beertable') do
      find('#style').click
    end

    styles = []

    find('#beertable').all('.tablerow').each do |tr|
      styles.append(tr.all('td').map(&:text)[1])
    end

    expect(styles).to eq(%w(Lager Rauchbier Weizen))
  end

  it 'sorts beer list by breweries', js: true do
    visit beerlist_path

    within('#beertable') do
      find('#brewery').click
    end

    breweries = []

    find('#beertable').all('.tablerow').each do |tr|
      breweries.append(tr.all('td').map(&:text)[2])
    end

    expect(breweries).to eq(%w(Ayinger Koff Schlenkerla))
  end
end
