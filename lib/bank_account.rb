# frozen_string_literal: true

require_relative "transaction"
require_relative "statement"

# BankAccount stores a balance and allows user to withdraw and deposit money
class BankAccount
  attr_reader :balance

  def initialize(transaction = Transaction, statement = Statement)
    @transaction_class = transaction
    @statement_class = statement
    @balance = 0
    @transactions = []
  end

  def deposit(amount)
    deposit = @transaction_class.new(sanitise_input(amount), @balance)
    process_transaction(deposit)
  end

  def withdraw(amount)
    withdrawal = @transaction_class.new(-sanitise_input(amount), @balance, "withdrawal")
    process_transaction(withdrawal)
  end

  def print_statement
    puts @statement_class.new(@transactions).final_output
  end

  private #--------------------------------------------------

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
