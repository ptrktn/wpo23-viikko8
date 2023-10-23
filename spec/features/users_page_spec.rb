require 'rails_helper'

describe "User" do
  include Helpers

  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      visit signin_path

      fill_in('username', with: 'Pekka')
      fill_in('password', with: 'wrong')
      click_button('Log in')

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "shows user's own ratings" do
      beer = create_beer_with_rating({ user: @user }, 10)
      beer2 = create_beer_with_rating({ user: FactoryBot.create(:user, username: 'Vilho') }, 20)

      visit user_path(@user)

      expect(page).to have_content "#{beer.name} 10"
      expect(page).not_to have_content "#{beer2.name} 20"
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path

    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{ User.count }.by(1)
  end
end
