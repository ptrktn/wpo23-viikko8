require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:name) { "Happy Cat" }
  let(:style) { "Lager" }
  let(:brewery) { Brewery.create(name: "Brew Cat", year: 2001) }

  describe "with valid arguments" do
    it "is saved" do
      beer = Beer.create(name:, style:, brewery:)

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "with invalid arguments" do
    context "when name is not given" do
      let(:name) { nil }
      it "is is not saved" do
        beer = Beer.create(name:, style:, brewery:)

        expect(beer).not_to be_valid
        expect(Beer.count).to eq(0)
      end
    end

    context "when style is not given" do
      let(:style) { nil }
      it "is not saved" do
        beer = Beer.create(name:, style:, brewery:)

        expect(beer).not_to be_valid
        expect(Beer.count).to eq(0)
      end
    end
  end
end
