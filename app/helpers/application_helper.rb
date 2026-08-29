module ApplicationHelper
  def prototype_price
    cents = LeftYouOne.config.display_price_cents
    amount = cents / 100.0
    precision = (cents % 100).zero? ? 0 : 2
    unit = LeftYouOne.config.display_currency == "USD" ? "$" : "#{LeftYouOne.config.display_currency} "
    number_to_currency(amount, unit:, precision:)
  end
end
