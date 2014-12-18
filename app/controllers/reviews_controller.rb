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

  # def destroy
  #   @restaurant = Restaurant.find(params[:id])
  #   @review = Review.find(params[:id])
  #   @restaurant_review = @restaurant.@review
  #   if current_user == nil || current_user.id != @restaurant_review.user_id
  #     flash[:notice] = "You cannot delete a review you haven't created"
  #     redirect_to restaurants_path
  #   else
  #     @restaurant_review.destroy
  #     flash[:notice] = "Review deleted successfully"
  #     redirect_to restaurants_path
  #   end
  # end

end
