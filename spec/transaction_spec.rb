require "transaction"

describe Transaction do


  it "returns a warning if a negative amount was given" do
    transaction = Transaction.new(-100)
    expect(transaction.error).to eq "Please enter a positive number."
  end

  it "prints a warning if amount 0 was given" do
    transaction = Transaction.new(0)
    expect(transaction.error).to eq "Please enter a positive number."
  end

  it "checks if the amount is a number" do
    transaction = Transaction.new(false)
    expect(transaction.error).to eq "Please enter a positive number."
  end

  describe "#valid_number?" do
    let(:transaction) { Transaction.new(10) }

    it "returns true for 12.4" do
      expect(transaction.valid_number?(12.4)).to be true
    end

    it "returns true for '12.4'" do
      expect(transaction.valid_number?('12.4')).to be true
    end

    it "returns false for 'hello'" do
      expect(transaction.valid_number?('hello')).to be false
    end

    it "returns false for bool" do
      expect(transaction.valid_number?(true)).to be false
    end
  end

  describe "#valid_transaction_amount" do
    let(:transaction) { Transaction.new(10) }

    before do
      allow(transaction).to receive(:valid_number?).and_return true
    end

    it "returns true for 100" do
      expect(transaction.valid_transaction_amount?(100)).to be true
    end

    it "returns false for 0" do
      expect(transaction.valid_transaction_amount?(0)).to be false
    end

    it "returns false for -100" do
      expect(transaction.valid_transaction_amount?(-100)).to be false
    end


  end

end
