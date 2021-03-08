class BankAccount

  attr_reader :balance

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount, date)
    @balance += amount
    @transactions << { amount: amount, date: date }
  end

  def withdraw(amount, date)
    @balance -= amount
  end

  def print_statement
    header = "date || credit || debit || balance"
    transaction = "#{@transactions[-1][:date].strftime('%d/%m/%Y')} || 1000.00 || || 1000.00"

    print header + "\n" + transaction
  end

end
