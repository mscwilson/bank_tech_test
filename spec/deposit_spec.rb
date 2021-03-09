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

  describe "#valid_number?" do
    let(:deposit) { Deposit.new(10) }

    it "returns true for 12.4" do
      expect(deposit.valid_number?(12.4)).to be true
    end

    it "returns true for '12.4'" do
      expect(deposit.valid_number?("12.4")).to be true
    end

    it "returns false for 'hello'" do
      expect(deposit.valid_number?("hello")).to be false
    end

    it "returns false for bool" do
      expect(deposit.valid_number?(true)).to be false
    end
  end

  describe "#valid_transaction_amount" do
    let(:deposit) { Deposit.new(10) }

    before do
      allow(deposit).to receive(:valid_number?).and_return true
    end

    it "returns true for 100" do
      expect(deposit.valid_transaction_amount?(100)).to be true
    end

    it "returns false for 0" do
      expect(deposit.valid_transaction_amount?(0)).to be false
    end

    it "returns false for -100" do
      expect(deposit.valid_transaction_amount?(-100)).to be false
    end
  end
end
