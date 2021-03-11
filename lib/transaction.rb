# frozen_string_literal: true

# Stores transaction info. Parent of Withdrawal and Deposit
class Transaction
  attr_reader :amount, :date, :error, :new_balance

  MAXIMUM_DEPOSIT_LIMIT = 10_000
  MAXIMUM_WITHDRAWAL_LIMIT = 2500

  def initialize(amount, balance = 0)
    @amount = amount.is_a?(String) && valid_number?(amount) ? convert_to_number(amount) : amount
    @date = Time.now
    @balance = balance
    @new_balance = successful? ? calculate_new_balance : @balance
    @error = error_message
  end


  def successful?
    if withdrawal?
      valid_transaction_amount?(@amount) && within_max_limit?(@amount) && !amount_more_than_balance?
    else
      valid_transaction_amount?(@amount) && within_max_limit?(@amount)
    end
  end

  def valid_transaction_amount?(number)
    if withdrawal?
      valid_number?(number) && number.negative? && number != 0
    else
      valid_number?(number) && number.positive? && number != 0
    end
  end

  def within_max_limit?(number)
    number < (withdrawal? ? MAXIMUM_WITHDRAWAL_LIMIT : MAXIMUM_DEPOSIT_LIMIT)
  end

  def calculate_new_balance
    @balance + @amount
  end

  def error_message
    return "Please enter a positive number." unless valid_transaction_amount?(@amount)
    return "Unable to process large request. Please speak to your bank manager." unless within_max_limit?(@amount)
    return "Insufficient funds." if amount_more_than_balance? && withdrawal?

    "N/A"
  end

  private #----------------------------------------

  def withdrawal?
    @amount.negative?
  end

  def amount_more_than_balance?
    calculate_new_balance.negative?
  end

  def valid_number?(number)
    true if Float(number)
  rescue StandardError
    false
  end

  def convert_to_number(number)
    Float(number)
  end
end
