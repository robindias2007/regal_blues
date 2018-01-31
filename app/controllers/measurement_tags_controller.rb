class MeasurementTagsController < ApplicationController
  # def new
  # end

  # def create
  # end

  # def update
  # end

  # def edit
  # end

  # def destroy
  # end

  # def show
  # end

  def index
    measurement_tags = MeasurementTag.all
    render json: { data: measurement_tags }
  end
end
