require "bank_account"

describe BankAccount do

  let(:account) { BankAccount.new }
  let(:statement_header) { "date || credit || debit || balance\n" }

  it "allows deposits to change balance" do
    expect{ account.deposit(100) }.to change{ account.balance }.by 100
  end

  describe "#withdraw" do
    it "allows withdrawals to change balance" do
      account.deposit(100, Time.now)
      expect{ account.withdraw(100) }.to change{ account.balance }.by -100
    end

    it "prevents withdrawals for more than current balance" do
      expect{ account.withdraw(100) }.to change{ account.balance }.by 0
      expect{ account.withdraw(100) }.to output("Insufficient funds.\n").to_stdout
    end
  end

  describe "#print_statement" do
    it "prints out a statement from given data" do
      transaction = "10/01/2012 || 1000.00 || || 1000.00"
      account.deposit(1000, Time.new(2012, 1, 10))
      expect{ account.print_statement }.to output(statement_header + transaction).to_stdout
    end

    it "prints details of a deposit from today" do
      # date = Time.now
      transaction = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      account.deposit(100)
      expect{ account.print_statement }.to output(statement_header + transaction).to_stdout
    end

    it "shows the balance at the time of transaction on statement" do
      account.deposit(100, Time.new(2012, 1, 10))
      account.deposit(100, Time.new(2012, 1, 11))

      transaction_str1 = "11/01/2012 || 100.00 || || 200.00\n"
      transaction_str2 = "10/01/2012 || 100.00 || || 100.00"
      full_statement = statement_header + transaction_str1 + transaction_str2

      expect{ account.print_statement }.to output(full_statement).to_stdout
    end

    it "prints details of a withdrawal" do
      account.deposit(1000, Time.new(2012, 1, 10))
      account.withdraw(500, Time.new(2012, 1, 14))

      transaction_str1 = "14/01/2012 || || 500.00 || 500.00\n"
      transaction_str2 = "10/01/2012 || 1000.00 || || 1000.00"
      full_statement = statement_header + transaction_str1 + transaction_str2

      expect{ account.print_statement }.to output(full_statement).to_stdout
    end

    it "says 'No transactions' if appropriate" do
      expect{ account.print_statement }.to output("No transactions to show.\n").to_stdout
    end
  end
end
