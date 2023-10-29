require 'rails_helper'

RSpec.describe User, type: :model do
  include Helpers

  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer:, user:)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer:, user:)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest rating if several rated" do
      delta = { "Lager" => 5, "Stout" => 10, "Weizen" => 15 }
      %w[Lager Stout Weizen].each do |name|
        create_beers_with_many_ratings(
          { user:, style: FactoryBot.create(:style, name: name)},
          delta[name] + 10,
          delta[name] + 20,
          delta[name] + 15,
          delta[name] + 7,
          delta[name] + 9
        )
      end

      expect(user.favorite_style).to eq(delta.key(delta.values.max))
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer:, user:)

      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the one with highest rating if several rated" do
      delta = { "Asahi" => 5, "Kirin" => 10, "Sapporo" => 15 }
      %w[Asahi Kirin Sapporo].each do |brewery_name|
        brewery = Brewery.create(name: brewery_name, year: 1970)
        create_beers_with_many_ratings(
          { user:, brewery: },
          delta[brewery_name] + 10,
          delta[brewery_name] + 20,
          delta[brewery_name] + 15,
          delta[brewery_name] + 7,
          delta[brewery_name] + 9
        )
      end

      expect(user.favorite_brewery).to eq(delta.key(delta.values.max))
    end
  end

  describe "with an invalid password" do
    let(:user) { User.create(username: "Pekka", password:, password_confirmation: password) }
    context "when passowrd is too short" do
      let(:password) { "abc" }

      it "is not saved" do
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
      end
    end

    context "when passowrd contains only lowercase letters" do
      let(:password) { "punavuoren ahven" }

      it "is not saved" do
        expect(user).not_to be_valid
        expect(User.count).to eq(0)
      end
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user:)
      FactoryBot.create(:rating, score: 20, user:)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
