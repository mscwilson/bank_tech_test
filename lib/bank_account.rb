require_relative "deposit"
require_relative "withdrawal"

class BankAccount
  attr_reader :balance

  STATEMENT_HEADER = "date || credit || debit || balance"

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    deposit = create_deposit(amount)
    deposit.successful? ? (@balance = deposit.new_balance) : (puts deposit.error)
    @transactions << deposit
  end

  def withdraw(amount)
    withdrawal = create_withdrawal(amount)
    withdrawal.successful? ? (@balance = withdrawal.new_balance) : (puts withdrawal.error)
    @transactions << withdrawal
  end

  def print_statement
    return puts "No transactions to show." if @transactions.length == 0
    puts transactions_to_strings.join("\n")
  end

  private #--------------------------------------------------

  def create_deposit(amount)
    Deposit.new(amount, @balance)
  end

  def create_withdrawal(amount)
    Withdrawal.new(amount, @balance)
  end

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
    date = transaction.date.strftime("%d/%m/%Y")
    amount = transaction.amount
    new_balance = transaction.new_balance

    if amount.positive?
      "#{date} || #{'%.2f' % amount} || || #{'%.2f' % new_balance}"
    else
      "#{date} || || #{'%.2f' % -amount} || #{'%.2f' % new_balance}"
    end
  end
end
