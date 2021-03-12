# frozen_string_literal: true

require "bank_account"

describe BankAccount do
  let(:fake_transaction_class) { double :Transaction }
  let(:fake_statement_class) { double :Statement }
  let(:account) { BankAccount.new(fake_transaction_class, fake_statement_class) }

  describe "#deposit" do
    before do
      @fake_deposit = double(:deposit)
      allow(@fake_deposit).to receive(:successful?).and_return true
      allow(@fake_deposit).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
      allow(@fake_deposit).to receive(:error).and_return "Please enter a positive number."
      allow(fake_transaction_class).to receive(:new).and_return(@fake_deposit)
    end

    it "adds amount onto balance if transaction was successful" do
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.to change { account.balance }.by DEFAULT_TRANSACTION_AMOUNT
    end

    it "converts a bad input into 0 for creating transaction" do
      expect(fake_transaction_class).to receive(:new).with(0, 0)
      account.deposit("hello")
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      expect { account.deposit(DEFAULT_TRANSACTION_AMOUNT) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#withdraw" do
    before do
      @fake_withdrawal = double(:withdrawal)
      allow(@fake_withdrawal).to receive(:successful?).and_return true
      allow(@fake_withdrawal).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
      allow(@fake_withdrawal).to receive(:error).and_return "Please enter a positive number."
      allow(fake_transaction_class).to receive(:new).and_return(@fake_withdrawal)
    end

    it "subtracts amount from balance" do
      allow(account).to receive(:balance).and_return(DEFAULT_TRANSACTION_AMOUNT, account.balance)
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.to change {
                                                                   account.balance
                                                                 }.by(-DEFAULT_TRANSACTION_AMOUNT)
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      expect { account.withdraw(DEFAULT_TRANSACTION_AMOUNT) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#print_statement" do
    before do
      @fake_statement = double(:statement)
      allow(@fake_statement).to receive(:final_output).and_return DEFAULT_STATEMENT
      allow(fake_statement_class).to receive(:new).and_return @fake_statement
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
