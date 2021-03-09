class Transaction

  def initialize(amount)
    @amount = amount
  end

  def error
    "Please enter a positive number." if !valid_transaction_amount?(@amount)
  end

  def valid_number?(number)
    true if Float(number)
    rescue StandardError
    false
  end

  def valid_transaction_amount?(amount)
    valid_number?(amount) && amount.positive? && amount != 0
  end

end
