class Transaction

  attr_reader :amount, :date, :balance, :error

  MAXIMUM_DEPOSIT_LIMIT = 10_000

  def initialize(amount, balance = 0)
    @amount = (amount.is_a?(String) && valid_number?(amount)) ? convert_to_number(amount) : amount
    @successful = valid_transaction_amount?(@amount)
    @date = Time.now
    @balance = balance
    @error = error_message
  end

  def error_message
    return "Please enter a positive number." unless valid_transaction_amount?(@amount)
    return "Unable to process large deposit. Please speak to your bank manager." unless within_max_limit?(@amount)
    "N/A"
  end

  def successful?
    @successful
  end

  def convert_to_number(number)
    Float(number)
  end

  def valid_number?(number)
    true if Float(number)
  rescue StandardError
    false
  end

  def within_max_limit?(number)
    number < MAXIMUM_DEPOSIT_LIMIT
  end

  def valid_transaction_amount?(number)
    valid_number?(number) && number.positive? && number != 0
  end
end
