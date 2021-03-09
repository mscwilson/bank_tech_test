class Statement

  def initialize(array)

  end

  def render_single_transaction(transaction)
    date = transaction.date.strftime("%d/%m/%Y")
    amount = transaction.amount
    new_balance = transaction.new_balance

    "#{date} || #{'%.2f' % amount} || || #{'%.2f' % new_balance}"
  end

end
