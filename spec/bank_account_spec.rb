require "bank_account"

describe BankAccount do

  let(:account) { BankAccount.new }
  let(:statement_header) { "date || credit || debit || balance\n" }

  describe "#deposit" do
    it "adds amount onto balance" do
      expect{ account.deposit(100) }.to change{ account.balance }.by 100
    end

    it "prints a warning if a negative amount was given" do
      expect{ account.deposit(-100) }.to output("Please enter a positive number.\n").to_stdout
    end

    it "prints a warning if amount 0 was given" do
      expect{ account.deposit(0) }.to output("Please enter a positive number.\n").to_stdout
    end

    it "checks if the amount is a number" do
      expect{ account.deposit(false) }.to output("Please enter a positive number.\n").to_stdout
    end

    it "allows amounts to be given as a string" do
      expect{ account.deposit("100") }.to change{ account.balance }.by 100
    end
  end

  describe "#withdraw" do
    it "subtracts amount from balance" do
      account.deposit(100)
      expect{ account.withdraw(100) }.to change{ account.balance }.by -100
    end

    it "prevents going overdrawn" do
      expect{ account.withdraw(100) }.not_to change{ account.balance }
    end

    it "prints a warning if withdrawl amount was greater than balance" do
      expect{ account.withdraw(100) }.to output("Insufficient funds.\n").to_stdout
    end

    it "prints a warning if a negative amount was given" do
      account.deposit(100)
      expect{ account.withdraw(-100) }.to output("Please enter a positive number.\n").to_stdout
    end

    it "prints a warning if amount 0 was given" do
      account.deposit(100)
      expect{ account.withdraw(0) }.to output("Please enter a positive number.\n").to_stdout
    end

    it "checks if the amount is a number" do
      expect{ account.withdraw("hello") }.to output("Please enter a positive number.\n").to_stdout
    end
  end

  describe "#print_statement" do
    it "prints out a statement from given data" do
      transaction = "10/01/2012 || 1000.00 || || 1000.00"
      account.deposit(1000, Time.new(2012, 1, 10))
      expect{ account.print_statement }.to output(statement_header + transaction).to_stdout
    end

    it "prints details of a deposit from today" do
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

    it "prints two decimal places" do
      account.deposit(100.34922)
      full_statement = statement_header + "#{Time.now.strftime('%d/%m/%Y')} || 100.35 || || 100.35"
      expect{ account.print_statement }.to output(full_statement).to_stdout
    end
  end
end
