module TicketsHelper
  def badge_class_for_tickets_state(state)
    case state
    when 'won' then 'bg-success'
    when 'lost' then 'bg-danger'
    when 'cancelled' then 'bg-secondary'
    else 'bg-primary'
    end
  end
end