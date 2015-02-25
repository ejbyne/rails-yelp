module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.respond_to?(:round)
    remainder = (5 - rating)
    '★' * rating.round + '☆' * remainder
  end

  def time_since_created(time_created)
    return pluralize((((Time.now - time_created) / 3600).round.to_s), 'hour') + " ago" if (Time.now - time_created) < 84600
    pluralize((((Time.now - time_created) / 86400).round.to_s), 'day') + " ago"
  end
end
