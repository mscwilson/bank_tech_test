# frozen_string_literal: true

require "bank_account"

describe "using the bank account" do
  let(:account) { BankAccount.new }

  it "making transactions then getting a statement" do
    allow(Time).to receive(:now).and_return(Time.new(2012, 1, 10))
    account.deposit(1000)
    allow(Time).to receive(:now).and_return(Time.new(2012, 1, 13))
    account.deposit(2000)
    allow(Time).to receive(:now).and_return(Time.new(2012, 1, 14))
    account.withdraw(500)
    expected = "date || credit || debit || balance\n"\
                "14/01/2012 || || 500.00 || 2500.00\n"\
                "13/01/2012 || 2000.00 || || 3000.00\n"\
                "10/01/2012 || 1000.00 || || 1000.00\n"

    expect { account.print_statement }.to output(expected).to_stdout
  end

  it "getting a statement before making transactions" do
    expect { account.print_statement }.to output("No transactions to show.\n").to_stdout
  end

  it "withdrawing without depositing" do
    expect { account.withdraw(100) }.to output("Insufficient funds.\n").to_stdout
  end

  it "depositing but then trying to withdraw more money than in the account" do
    account.deposit(1000)
    account.withdraw(100)
    account.withdraw(100)
    expect { account.withdraw(900) }.to output("Insufficient funds.\n").to_stdout

    expected = "#{STATEMENT_HEADER}\n"\
              "#{Time.now.strftime('%d/%m/%Y')} || || 100.00 || 800.00\n"\
              "#{Time.now.strftime('%d/%m/%Y')} || || 100.00 || 900.00\n"\
              "#{Time.now.strftime('%d/%m/%Y')} || 1000.00 || || 1000.00\n"

    expect { account.print_statement }.to output(expected).to_stdout
  end
end
