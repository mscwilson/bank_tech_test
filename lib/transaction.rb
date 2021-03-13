# frozen_string_literal: true

# Stores transaction info
class Transaction
  attr_reader :amount, :date, :error, :new_balance

  MAXIMUM_DEPOSIT_LIMIT = 10_000
  MAXIMUM_WITHDRAWAL_LIMIT = 2500

  def initialize(amount, balance = 0, type = "deposit", date = Time.now)
    @amount = amount
    @date = date
    @balance = balance
    @type = type
    @new_balance = successful? ? calculate_new_balance : @balance
    @error = error_message
  end

  def successful?
    return false if withdrawal? && amount_more_than_balance?

    valid_transaction_amount? && within_max_limit?
  end

  private #----------------------------------------

  def withdrawal?
    @type == "withdrawal"
  end

  def amount_more_than_balance?
    calculate_new_balance.negative?
  end

  def valid_transaction_amount?(number = @amount)
    return false if number.zero?

    withdrawal? ? number.negative? : number.positive?
  end

  def within_max_limit?(number = @amount)
    number < (withdrawal? ? MAXIMUM_WITHDRAWAL_LIMIT : MAXIMUM_DEPOSIT_LIMIT)
  end

  def calculate_new_balance
    @balance + @amount
  end

  def error_message
    return "Please enter a positive number." unless valid_transaction_amount?

    unless within_max_limit?
      return "Unable to process large request. "\
              "Please speak to your bank manager."
    end
    return "Insufficient funds." if amount_more_than_balance? && withdrawal?

    "N/A"
  end
end
