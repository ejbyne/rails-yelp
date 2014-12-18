class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if @restaurant.reviews.any?
      @restaurant.reviews.each do |review|  
        if current_user.id == review.user_id
          flash[:notice] = 'You cannot leave more than 1 review per restaurant'
          redirect_to restaurants_path
        end
      end
    end
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)
    @review.user_id = current_user.id
    @review.save
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end



end
