# frozen_string_literal: true

require_relative "transaction"

# Converts a list of Transaction objects into a statement to print out
class Statement
  HEADER = "date || credit || debit || balance"

  def initialize(transactions)
    @transactions = transactions
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
    new_balance = format("%.2f", transaction.new_balance)
    if transaction.amount.positive?
      amount = format("%.2f", transaction.amount)
      return "#{date} || #{amount} || || #{new_balance}"
    else
      amount = format("%.2f", -transaction.amount)
      return "#{date} || || #{amount} || #{new_balance}"
    end
  end

  private #--------------------------------------

  attr_reader :transactions
end
