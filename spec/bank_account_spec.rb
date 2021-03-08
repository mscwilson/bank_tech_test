require "bank_account"

describe "bank_account" do

  it "allows deposits to change balance" do
    account = BankAccount.new
    expect{ account.deposit(100, Time.now) }.to change{ account.balance }.by 100
  end

end
