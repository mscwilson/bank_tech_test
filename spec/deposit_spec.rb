require "deposit"

describe Deposit do

  it "returns a warning if a negative amount was given" do
    deposit = Deposit.new(-100)
    expect(deposit.error).to eq "Please enter a positive number."
  end

  it "prints a warning if amount 0 was given" do
    deposit = Deposit.new(0)
    expect(deposit.error).to eq "Please enter a positive number."
  end

  it "checks if the amount is a number" do
    deposit = Deposit.new(false)
    expect(deposit.error).to eq "Please enter a positive number."
  end


end
