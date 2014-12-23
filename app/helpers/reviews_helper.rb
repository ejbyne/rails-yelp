module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = (5 - rating)
    '★' * rating.round + '☆' * remainder
  end

  def time_since_created(time_created)
    return ((Time.now - time_created) / 3600).round.to_s + " hours ago" if (Time.now - time_created) < 84600
    ((Time.now - time_created) / 86400).round.to_s + " days ago"
  end
end
