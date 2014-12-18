class EndorsementsController < ApplicationController

  def create
    @review = Review.find(params[:reviewid])
    @review.endorsements.create
    redirect_to restaurants_path
  end

end
