module OffersHelper

  def badge_class_for_offers_genre(genre)
    case genre
    when 'daily' then 'bg-primary'
    when 'weekly' then 'bg-secondary'
    when 'monthly' then 'bg-info'
    when 'one_time' then 'bg-danger'
    else 'bg-success'
    end
  end
end