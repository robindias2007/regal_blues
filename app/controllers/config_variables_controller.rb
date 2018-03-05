class ConfigVariablesController < ApplicationController
  before_action :set_config_variable, only: [:show, :edit, :update, :destroy]

  # GET /config_variables
  def index
    @config_variables = ConfigVariable.all
  end

  def all_configurations
    @config_variables = ConfigVariable.all
    if @config_variables
      render json: @config_variables
    end
  end

  # GET /config_variables/1
  def show
  end

  # GET /config_variables/new
  def new
    @config_variable = ConfigVariable.new
  end

  # GET /config_variables/1/edit
  def edit
  end

  # POST /config_variables
  def create
    @config_variable = ConfigVariable.new(config_variable_params)

    if @config_variable.save
      redirect_to @config_variable, notice: 'Config variable was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /config_variables/1
  def update
    if @config_variable.update(config_variable_params)
      redirect_to @config_variable, notice: 'Config variable was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /config_variables/1
  def destroy
    @config_variable.destroy
    redirect_to config_variables_url, notice: 'Config variable was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config_variable
      @config_variable = ConfigVariable.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def config_variable_params
      params.require(:config_variable).permit(:event_name, :param1, :param2, :param3, :param4)
    end
end
