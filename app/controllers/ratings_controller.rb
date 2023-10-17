class RatingsController < ApplicationController
  
  # GET /ratings or /ratingss.json
  def index
    @ratings = Rating.all
  end

end
