class Transaction

  attr_reader :amount, :date, :balance, :successful

  MAXIMUM_DEPOSIT_LIMIT = 10_000

  def initialize(amount, balance = 0)
    @amount = amount
    @date = Time.now
    @balance = balance
    @successful = valid_transaction_amount?(@amount)
  end

  def error
    "Please enter a positive number." unless valid_transaction_amount?(@amount)
  end

  def successful?
    @successful
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
    valid_number?(number) && number.positive? && number != 0 && within_max_limit?(number)
  end
end
