# frozen_string_literal: true

require "bank_account"

describe BankAccount do
  let(:account) { BankAccount.new }
  let(:statement_header) { "date || credit || debit || balance\n" }

  describe "#deposit" do
    before do
      @fake_deposit = double(:deposit)
      allow(account).to receive(:create_deposit).and_return @fake_deposit
      allow(@fake_deposit).to receive(:successful?).and_return true
      allow(@fake_deposit).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
    end

    it "adds amount onto balance if transaction was successful" do
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.to change{ account.balance }.by DEFAULT_TRANSACTION_AMOUNT
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      allow(@fake_deposit).to receive(:error)
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      allow(@fake_deposit).to receive(:error).and_return "Please enter a positive number."
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#withdraw" do
    before do
      @fake_withdrawal = double(:withdrawal)
      allow(account).to receive(:create_withdrawal).and_return @fake_withdrawal
      allow(@fake_withdrawal).to receive(:successful?).and_return true
      allow(@fake_withdrawal).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
    end

    it "subtracts amount from balance" do
      allow(account).to receive(:balance).and_return(DEFAULT_TRANSACTION_AMOUNT, account.balance)
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.to change {
                                                                   account.balance
                                                                 }.by(-DEFAULT_TRANSACTION_AMOUNT)
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      allow(@fake_withdrawal).to receive(:error)
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      allow(@fake_withdrawal).to receive(:error).and_return "Please enter a positive number."
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#print_statement" do
    before do
      @fake_statement = double(:statement)
      allow(account).to receive(:create_statement).and_return @fake_statement
      allow(@fake_statement).to receive(:final_output).and_return DEFAULT_STATEMENT
    end

    it "prints details of a transaction" do
      expect { account.print_statement }.to output(DEFAULT_STATEMENT).to_stdout
    end

    it "says 'No transactions' if appropriate" do
      allow(@fake_statement).to receive(:final_output).and_return "No transactions to show."
      expect { account.print_statement }.to output("No transactions to show.\n").to_stdout
    end
  end
end
