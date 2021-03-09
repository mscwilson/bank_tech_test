# frozen_string_literal: true

require_relative "deposit"
require_relative "withdrawal"
require_relative "statement"

# BankAccount stores a balance and allows user to withdraw and deposit money
class BankAccount
  attr_reader :balance

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
    puts create_statement.final_output
  end

  private #--------------------------------------------------

  def create_deposit(amount)
    Deposit.new(amount, @balance)
  end

  def create_withdrawal(amount)
    Withdrawal.new(amount, @balance)
  end

  def create_statement
    Statement.new(@transactions)
  end
end
