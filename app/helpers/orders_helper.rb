module OrdersHelper
  def badge_class_for_orders_state(state)
    case state
    when 'pending' then 'bg-primary'
    when 'submitted' then 'bg-info'
    when 'cancelled' then 'bg-secondary'
    when 'paid' then 'bg-success'
    else 'bg-light'
    end
  end

  def badge_class_for_orders_genre(genre)
    case genre
    when 'deposit' then 'bg-primary'
    when 'increase' then 'bg-success'
    when 'deduct' then 'bg-danger'
    when 'bonus' then 'bg-info'
    when 'member_level' then 'bg-dark'
    when 'share' then 'bg-warning'
    else 'bg-light'
    end
  end
end