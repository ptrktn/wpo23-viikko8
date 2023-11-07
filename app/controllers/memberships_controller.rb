class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy confirm]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all - current_user.beer_clubs
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_url(@membership.beer_club_id), notice: "#{current_user.username} welcome to the club." }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    user = User.find(@membership.user_id)
    beer_club_name = BeerClub.find(@membership.beer_club_id)

    @membership.destroy

    respond_to do |format|
      format.html { redirect_to user_url(user), notice: "Membership in #{beer_club_name} ended." }
      format.json { head :no_content }
    end
  end

  def confirm
    notice =
      if Membership.find_by(beer_club_id: @membership.beer_club_id, user_id: current_user, confirmed: true)
        @membership.update(confirmed: true)
        "User #{User.find_by(id: @membership.user_id).username} is now a confirmed member of #{BeerClub.find_by(id: @membership.beer_club_id).name}"
      else
        "Only members can confirm users"
      end

    redirect_to beer_club_url(@membership.beer_club_id), notice:
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
