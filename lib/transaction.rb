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

  def withdrawal?
    @amount.negative?
  end

  def valid_number?(number)
    true if Float(number)
  rescue StandardError
    false
  end

  def convert_to_number(number)
    Float(number)
  end

  def successful?
    valid_transaction_amount?(@amount) && within_max_limit?(@amount)
  end

  def valid_transaction_amount?(number)
    valid_number?(number) && number.positive? && number != 0
  end

  def within_max_limit?(number)
    number < (withdrawal? ? MAXIMUM_WITHDRAWAL_LIMIT : MAXIMUM_DEPOSIT_LIMIT)
  end

  def calculate_new_balance
    @balance + @amount
  end

  def error_message
    return "Please enter a positive number." unless valid_transaction_amount?(@amount)
    return "Unable to process large deposit. Please speak to your bank manager." unless within_max_limit?(@amount)

    "N/A"
  end

  private #----------------------------------------

  def amount_more_than_balance?
    @amount > @balance
  end

end



  # def error_message
  #   return "Please enter a positive number." unless valid_transaction_amount?(@amount)
  #   return "Insufficient funds." if amount_more_than_balance?
  #   return "Unable to process large deposit. Please speak to your bank manager." unless within_max_limit?(@amount)

  #   "N/A"
  # end
