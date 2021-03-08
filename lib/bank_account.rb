class BankAccount

  attr_reader :balance

  STATEMENT_HEADER = "date || credit || debit || balance"

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount, date = Time.now)
    if amount.is_a? String
      begin
        amount = Float(amount)
      rescue
        return puts "Please enter a positive number."
      end
    end

    return puts "Please enter a positive number." if !valid_amount?(amount)

    @balance += amount
    @transactions << { amount: amount, date: date, then_balance: @balance}
  end

  def withdraw(amount, date = Time.now)
    return puts "Please enter a positive number." if !valid_amount?(amount)
    return puts "Insufficient funds." if amount > @balance

    @balance -= amount
    @transactions << { amount: -amount, date: date, then_balance: @balance}
  end

  def print_statement
    return puts "No transactions to show." if @transactions.length == 0

    print transactions_to_strings.join("\n")
  end

  private #--------------------------------------------------

  def valid_amount?(amount)
    amount.is_a?(Numeric) && amount.positive? && amount != 0
  end

  def transactions_to_strings
    transaction_strings = [STATEMENT_HEADER]
    @transactions.reverse.each do |transaction|
      transaction_strings << render_single_transaction(transaction)
    end
    transaction_strings
  end

  def render_single_transaction(transaction)
    date = transaction[:date].strftime('%d/%m/%Y')
    amount = transaction[:amount]
    then_balance = transaction[:then_balance]

    if amount.positive?
      "#{date} || #{"%.2f" % amount} || || #{"%.2f" % then_balance}"
    else
      "#{date} || || #{"%.2f" % -amount} || #{"%.2f" % then_balance}"
    end
  end

end
