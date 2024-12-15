module WinnersHelper
  def badge_class_for_winners_state(state)
    case state
    when 'won', 'claimed' then 'bg-success'
    when 'paid', 'submitted' then 'bg-primary'
    when 'shipped' then 'bg-warning'
    when 'delivered' then 'bg-info'
    when 'published' then 'bg-secondary'
    when 'shared' then 'bg-dark'
    when 'remove_published' then 'bg-danger'
    else 'bg-light'
    end
  end
end