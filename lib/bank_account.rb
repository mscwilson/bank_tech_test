class BankAccount
  attr_reader :balance

  STATEMENT_HEADER = "date || credit || debit || balance"

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    amount = Float(amount) if amount.is_a?(String) && valid_number?(amount)
    return puts "Please enter a positive number." unless valid_transaction_amount?(amount)
    return puts "Unable to process large deposit. Please speak to your bank manager." if amount >= 10000

    @balance += amount
    @transactions << { amount: amount, date: Time.now, then_balance: @balance }
  end

  def withdraw(amount)
    return puts "Please enter a positive number." unless valid_transaction_amount?(amount)
    return puts "Insufficient funds." if amount > @balance
    return puts "Amount exceeds daily limit. Please speak to your bank manager to withdraw large sums." if amount > 2500

    @balance -= amount
    @transactions << { amount: -amount, date: Time.now, then_balance: @balance }
  end

  def print_statement
    return puts "No transactions to show." if @transactions.length == 0

    puts transactions_to_strings.join("\n")
  end

  private #--------------------------------------------------

  def valid_number?(number)
    true if Float(number)
    rescue StandardError
    false
  end

  def valid_transaction_amount?(amount)
    valid_number?(amount) && amount.positive? && amount != 0
  end

  def transactions_to_strings
    transaction_strings = [STATEMENT_HEADER]
    @transactions.reverse.each do |transaction|
      transaction_strings << render_single_transaction(transaction)
    end
    transaction_strings
  end

  def render_single_transaction(transaction)
    date = transaction[:date].strftime("%d/%m/%Y")
    amount = transaction[:amount]
    then_balance = transaction[:then_balance]

    if amount.positive?
      "#{date} || #{'%.2f' % amount} || || #{'%.2f' % then_balance}"
    else
      "#{date} || || #{'%.2f' % -amount} || #{'%.2f' % then_balance}"
    end
  end
end
