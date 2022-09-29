class BoothsController < ApplicationController
  def index
    @booths = Booth.all
  end

  def new
  end

  def show
    @booth = Booth.find(params[:id]).as_prop
  end

  def create
    booth = Booth.create!(booth_params)
    redirect_to booth
  end

  private
  def booth_params
    params.require(:booth).permit(:name)
  end
end
