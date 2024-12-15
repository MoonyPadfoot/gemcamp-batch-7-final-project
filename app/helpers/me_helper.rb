module MeHelper
  def badge_class_for_order_history(state)
    case state
    when 'pending' then 'bg-primary'
    when 'submitted' then 'bg-info'
    when 'cancelled' then 'bg-secondary'
    else 'bg-success'
    end
  end

  def badge_class_for_lottery_history(state)
    case state
    when 'won' then 'bg-success'
    when 'lost' then 'bg-danger'
    when 'cancelled' then 'bg-secondary'
    else 'bg-primary'
    end
  end
end