require "bank_account"

describe BankAccount do

  let(:account) { BankAccount.new }
  let(:statement_header) { "date || credit || debit || balance\n" }

  it "allows deposits to change balance" do
    expect{ account.deposit(100, Time.now) }.to change{ account.balance }.by 100
  end

  it "allows withdrawals to change balance" do
    account.deposit(100, Time.now)
    expect{ account.withdraw(100, Time.now) }.to change{ account.balance }.by -100
  end

  it "prints out a statement from given data" do
    transaction = "10/01/2012 || 1000.00 || || 1000.00"
    account.deposit(1000, Time.new(2012, 1, 10))
    expect{ account.print_statement }.to output(statement_header + transaction).to_stdout
  end

  it "prints out a statement based on current date" do
    date = Time.now
    transaction = "#{date.strftime('%d/%m/%Y')} || 1000.00 || || 1000.00"
    account.deposit(1000, Time.now)
    expect{ account.print_statement }.to output(statement_header + transaction).to_stdout
  end

end
