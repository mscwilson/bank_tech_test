# frozen_string_literal: true

require_relative "transaction"

# Stores info about withdrawals to use with BankAccount
class Withdrawal < Transaction
  MAXIMUM_LIMIT = 2500

  def successful?
    valid_transaction_amount?(@amount) && within_max_limit?(@amount) && !amount_more_than_balance?
  end

  def within_max_limit?(number)
    number < MAXIMUM_LIMIT
  end

  def amount_more_than_balance?
    @amount > @balance
  end

  def calculate_new_balance
    @balance - @amount
  end

  def error_message
    return "Please enter a positive number." unless valid_transaction_amount?(@amount)
    return "Insufficient funds." if amount_more_than_balance?
    return "Unable to process large deposit. Please speak to your bank manager." unless within_max_limit?(@amount)

    "N/A"
  end

end
