# frozen_string_literal: true

require_relative "transaction"
require_relative "statement"

# BankAccount stores a balance and allows user to withdraw and deposit money
class BankAccount
  attr_reader :balance

  def initialize
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    deposit = create_transaction(sanitise_input(amount))
    process_transaction(deposit)
  end

  def withdraw(amount)
    withdrawal = create_transaction(-sanitise_input(amount))
    process_transaction(withdrawal)
  end

  def print_statement
    puts create_statement.final_output
  end

  private #--------------------------------------------------

  def create_transaction(amount)
    Transaction.new(amount, @balance)
  end

  def create_statement
    Statement.new(@transactions)
  end

  def process_transaction(transaction)
    transaction.successful? ? (@balance = transaction.new_balance) : (puts transaction.error)
    @transactions << transaction
  end

  def sanitise_input(input)
    valid_number?(input) ? convert_to_number(input) : 0
  end

  def valid_number?(number)
    true if Float(number)
  rescue StandardError
    false
  end

  def convert_to_number(number)
    Float(number)
  end
end


