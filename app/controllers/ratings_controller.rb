class RatingsController < ApplicationController
  # GET /ratings or /ratingss.json
  def index
    @top_beers = Rails.cache.fetch('top_beers', expires_in: 1.hour) { Beer.top 3 }
    @top_breweries = Rails.cache.fetch('top_breweries', expires_in: 1.hour) { Brewery.top 3 }
    @top_styles = Rails.cache.fetch('top_styles', expires_in: 1.hour) { Style.top 3 }
    @top_users = Rails.cache.fetch('top_users', expires_in: 1.hour) { User.top 3 }
    @recent = Rails.cache.fetch('recent_ratings', expires_in: 1.hour) { Rating.recent }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      expire_fragment("brewerylist")
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    expire_fragment("brewerylist")
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
