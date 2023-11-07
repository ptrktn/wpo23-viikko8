class BeerClubsController < ApplicationController
  before_action :set_beer_club, only: %i[show edit update destroy]
  before_action :set_membership_applications, only: %i[show]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /beer_clubs or /beer_clubs.json
  def index
    order = params[:order]

    @beer_clubs =
      if %w[city founded].include?(order)
        BeerClub.order(order.to_sym)
      else
        BeerClub.order(:name)
      end
  end

  # GET /beer_clubs/1 or /beer_clubs/1.json
  def show
    @membership = Membership.new(beer_club: @beer_club)
  end

  # GET /beer_clubs/new
  def new
    @beer_club = BeerClub.new
  end

  # GET /beer_clubs/1/edit
  def edit
  end

  # POST /beer_clubs or /beer_clubs.json
  def create
    @beer_club = BeerClub.new(beer_club_params)

    respond_to do |format|
      if @beer_club.save
        Membership.create(beer_club: @beer_club, user: current_user, confirmed: true)
        format.html { redirect_to beer_club_url(@beer_club), notice: "Beer club was successfully created." }
        format.json { render :show, status: :created, location: @beer_club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beer_clubs/1 or /beer_clubs/1.json
  def update
    respond_to do |format|
      if @beer_club.update(beer_club_params)
        format.html { redirect_to beer_club_url(@beer_club), notice: "Beer club was successfully updated." }
        format.json { render :show, status: :ok, location: @beer_club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beer_clubs/1 or /beer_clubs/1.json
  def destroy
    @beer_club.destroy

    respond_to do |format|
      format.html { redirect_to beer_clubs_url, notice: "Beer club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer_club
    @beer_club = BeerClub.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def beer_club_params
    params.require(:beer_club).permit(:name, :founded, :city)
  end

  def set_membership_applications
    @membership_applications =
      if Membership.find_by(beer_club: @beer_club, user: current_user)
        User
          .where(id: Membership.where(beer_club_id: 3, confirmed: [nil, false]).pluck(:user_id))
      else
        []
      end
  end
end
