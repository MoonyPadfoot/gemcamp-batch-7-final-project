module ApplicationHelper
  def format_to_currency(number = 0)
    number_to_currency(number, :unit => "P ", :separator => ".", :delimiter => ",")
  end
end
