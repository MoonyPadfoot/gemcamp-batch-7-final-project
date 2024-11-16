module WinningHistoriesHelper
  def may_claim_prize?(winning_history)
    Winner.includes(:ticket).find_by(
      ticket_id: winning_history.id,
      item_id: winning_history.item_id,
      item_batch_count: winning_history.batch_count
    ).may_claim?
  end
end