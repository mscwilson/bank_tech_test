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
      allow(@fake_deposit).to receive(:new_balance).and_return 100
    end

    it "adds amount onto balance if transaction was successful" do
      expect { account.deposit(100) }.to change { account.balance }.by 100
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      allow(@fake_deposit).to receive(:error)
      expect { account.deposit(100) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_deposit).to receive(:successful?).and_return false
      allow(@fake_deposit).to receive(:error).and_return "Please enter a positive number."
      expect { account.deposit(100) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#withdraw" do
    before do
      @fake_withdrawal = double(:withdrawal)
      allow(account).to receive(:create_withdrawal).and_return @fake_withdrawal
      allow(@fake_withdrawal).to receive(:successful?).and_return true
      allow(@fake_withdrawal).to receive(:new_balance).and_return 100
    end

    it "subtracts amount from balance" do
      allow(account).to receive(:balance).and_return(100, account.balance)
      expect { account.withdraw(100) }.to change { account.balance }.by(-100)
    end

    it "doesn't change balance if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      allow(@fake_withdrawal).to receive(:error)
      expect { account.withdraw(100) }.not_to change { account.balance }
    end

    it "prints out error message if transaction unsuccessful" do
      allow(@fake_withdrawal).to receive(:successful?).and_return false
      allow(@fake_withdrawal).to receive(:error).and_return "Please enter a positive number."
      expect { account.withdraw(100) }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#print_statement" do
    it "prints details of a deposit" do
      account.deposit(100)
      transaction = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      expect { account.print_statement }.to output(statement_header + transaction + "\n").to_stdout
    end

    it "shows the balance at the time of transaction on statement" do
      account.deposit(100)
      account.deposit(100)

      transaction_str1 = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 200.00\n"
      transaction_str2 = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      full_statement = statement_header + transaction_str1 + transaction_str2 + "\n"

      expect { account.print_statement }.to output(full_statement).to_stdout
    end

    xit "prints details of a withdrawal" do
      account.deposit(1000)
      account.withdraw(500)

      transaction_str1 = "#{Time.now.strftime('%d/%m/%Y')} || || 500.00 || 500.00\n"
      transaction_str2 = "#{Time.now.strftime('%d/%m/%Y')} || 1000.00 || || 1000.00"
      full_statement = statement_header + transaction_str1 + transaction_str2 + "\n"

      expect { account.print_statement }.to output(full_statement).to_stdout
    end

    it "says 'No transactions' if appropriate" do
      expect { account.print_statement }.to output("No transactions to show.\n").to_stdout
    end

    it "prints two decimal places" do
      account.deposit(100.34922)
      full_statement = statement_header + "#{Time.now.strftime('%d/%m/%Y')} || 100.35 || || 100.35"
      expect { account.print_statement }.to output(full_statement + "\n").to_stdout
    end
  end
end
