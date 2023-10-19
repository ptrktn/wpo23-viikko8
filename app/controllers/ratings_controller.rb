class RatingsController < ApplicationController
  
  # GET /ratings or /ratingss.json
  def index
    @ratings = Rating.all
  end
  
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end
end