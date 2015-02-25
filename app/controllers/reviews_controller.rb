class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if !current_user
      flash[:notice] = 'You must log in to leave a review'
      redirect_to restaurant_path(@restaurant)
    elsif @restaurant.reviews.any?
      @restaurant.reviews.each do |review|  
        if current_user && current_user.id == review.user_id
          flash[:notice] = 'You cannot leave more than 1 review per restaurant'
          redirect_to restaurant_path(@restaurant)
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
    redirect_to restaurant_path(@restaurant)
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  def destroy
    @review = Review.find(params[:id])
    @restaurant = Restaurant.find(@review.restaurant_id)
    if current_user == nil || current_user.id != @review.user_id
      flash[:notice] = "You cannot delete a review you haven't created"
      redirect_to restaurant_path(@restaurant)
    else
      @review.destroy
      flash[:notice] = "Review deleted successfully"
      redirect_to restaurant_path(@restaurant)
    end
  end

end
