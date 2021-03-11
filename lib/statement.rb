# frozen_string_literal: true

require_relative "deposit"

# Converts a list of Transaction objects into a statement to print out
class Statement
  HEADER = "date || credit || debit || balance"

  def initialize(array)
    @transactions = array
  end

  def final_output
    transactions? ? transactions_to_strings.join("\n") : "No transactions to show."
  end

  def transactions?
    !@transactions.empty?
  end

  def transactions_to_strings
    transaction_strings = [HEADER]
    transactions.reverse.each do |transaction|
      next unless transaction.successful?

      transaction_strings << render_single_transaction(transaction)
    end
    transaction_strings
  end

  def render_single_transaction(transaction)
    date = transaction.date.strftime("%d/%m/%Y")
    amount = format("%.2f", transaction.amount)
    new_balance = format("%.2f", transaction.new_balance)

    deposit_str = "#{date} || #{amount} || || #{new_balance}"
    withdrawal_str = "#{date} || || #{amount} || #{new_balance}"

    transaction.instance_of?(Deposit) ? deposit_str : withdrawal_str
  end

  private #--------------------------------------

  attr_reader :transactions
end
