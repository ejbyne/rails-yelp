module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = (5 - rating)
    '★' * rating.round + '☆' * remainder
  end

  # def time_created(time)
  #   '0'
  # end
end
