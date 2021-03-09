# frozen_string_literal: true

class Statement
  HEADER = "date || credit || debit || balance"

  def initialize(array)
    @transactions = array
  end

  def render_single_transaction(transaction)
    date = transaction.date.strftime("%d/%m/%Y")
    amount = transaction.amount
    new_balance = transaction.new_balance

    deposit_str = "#{date} || #{'%.2f' % amount} || || #{'%.2f' % new_balance}"
    withdrawal_str = "#{date} || || #{'%.2f' % amount} || #{'%.2f' % new_balance}"

    transaction.instance_of?(Deposit) ? deposit_str : withdrawal_str
  end

  def transactions_to_strings
    transaction_strings = [HEADER]
    @transactions.reverse.each do |transaction|
      transaction_strings << render_single_transaction(transaction)
    end
    transaction_strings
  end

  def transactions?
    !@transactions.empty?
  end

  def final_output
    transactions? ? transactions_to_strings.join("\n") : "No transactions to show."
  end
end
