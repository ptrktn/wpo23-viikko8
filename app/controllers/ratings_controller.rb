class RatingsController < ApplicationController
  PAGE_SIZE = 10

  before_action :set_rating, only: %w[show]

  # GET /ratings or /ratingss.json
  def index
    @top_beers = Rails.cache.fetch('top_beers', expires_in: 1.hour) { Beer.top 3 }
    @top_breweries = Rails.cache.fetch('top_breweries', expires_in: 1.hour) { Brewery.top 3 }
    @top_styles = Rails.cache.fetch('top_styles', expires_in: 1.hour) { Style.top 3 }
    @top_users = Rails.cache.fetch('top_users', expires_in: 1.hour) { User.top 3 }
    # FIXME
    @order = params[:order] || 'desc'
    @page = params[:page]&.to_i || 1
    @last_page = (Rating.count / PAGE_SIZE).ceil
    offset = (@page - 1) * PAGE_SIZE

    @recent =
      if @order == 'asc'
        Rating
          .order(created_at: :asc)
          .limit(PAGE_SIZE)
          .offset(offset)
      else
        Rating
          .order(created_at: :desc)
          .limit(PAGE_SIZE)
          .offset(offset)
      end
  end

  def show
    return unless turbo_frame_request?

    render partial: 'details', locals: { rating: @rating }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end

  private

  def set_rating
    @rating = Rating.find(params[:id])
  end
end
