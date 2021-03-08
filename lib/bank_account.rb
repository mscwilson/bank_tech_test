class BankAccount

  attr_reader :balance

  STATEMENT_HEADER = "date || credit || debit || balance"

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount, date)
    @balance += amount
    @transactions << { amount: amount, date: date, then_balance: @balance}
  end

  def withdraw(amount, date)
    @balance -= amount
  end

  def print_statement
    transaction_strings = [STATEMENT_HEADER]

    @transactions.reverse.each do |transaction|
      transaction_strings << render_transaction(transaction)
    end

    print transaction_strings.join("\n")
  end

  def render_transaction(transaction)
    date = transaction[:date].strftime('%d/%m/%Y')
    amount = transaction[:amount]
    then_balance = transaction[:then_balance]

    "#{date} || #{amount}.00 || || #{then_balance}.00"
  end

end
