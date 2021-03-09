class Deposit

  def initialize(amount)
    @amount = amount
  end

  def error
    "Please enter a positive number." if @amount.negative? || @amount == 0
  end

end
