class PicksController < ApplicationController
  before_action :set_pick, only: [:show, :edit, :update, :destroy]

  # GET /picks
  def index
    @picks = Pick.all
  end

  # GET /picks/1
  def show
  end

  # GET /picks/new
  def new
    @pick = Pick.new
  end

  # GET /picks/1/edit
  def edit
  end

  # POST /picks
  def create
    @pick = Pick.new(pick_params)

    if @pick.save
      redirect_to @pick, notice: 'Pick was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /picks/1
  def update
    if @pick.update(pick_params)
      redirect_to @pick, notice: 'Pick was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /picks/1
  def destroy
    @pick.destroy
    redirect_to picks_url, notice: 'Pick was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pick
      @pick = Pick.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pick_params
      params.require(:pick).permit(:cat_name, :keywords, {images: []})
    end
end
