class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    if user
      session[:user_id] = user.id
      # uudelleen ohjataan käyttäjä omalle sivulleen
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to signin_path, notice: "User #{params[:username]} does not exist!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
