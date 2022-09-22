class BoothsController < ApplicationController
  def index
    @booths = Booth.all
  end
end
