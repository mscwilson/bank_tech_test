require "transaction"

describe Transaction do
  let(:transaction) { Transaction.new(100) }

  describe "has instance variables" do
    it "stores the amount" do
      expect(transaction.amount).to eq 100
    end

    it "allows use of string number inputs" do
      allow_any_instance_of(Transaction).to receive(:convert_to_number).and_return 100
      transaction = Transaction.new("100")
      expect(transaction.amount).to eq 100
    end

    it "stores the date" do
      allow(Time).to receive(:now).and_return("14/01/2012")
      transaction = Transaction.new(100)
      expect(transaction.date).to eq "14/01/2012"
    end

    it "stores the balance given" do
      transaction = Transaction.new(100, 1000)
      expect(transaction.balance).to eq 1000
    end
  end

  describe "#successful?" do
    it "true if valid_transaction_amount? is true" do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return true
      transaction = Transaction.new(100)
      expect(transaction.successful?).to be true
    end

    it "false if valid_transaction_amount? is false" do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return false
      transaction = Transaction.new(100)
      expect(transaction.successful?).to be false
    end
  end

  describe "#error_message" do
    it "'unable to process large amount' if within_max_limit? false" do
      allow_any_instance_of(Transaction).to receive(:within_max_limit?).and_return false
      transaction = Transaction.new(100)
      expect(transaction.error_message).to eq "Unable to process large deposit. Please speak to your bank manager."
    end

    it "'enter a positive number' if valid_transaction_amount? false" do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return false
      transaction = Transaction.new(100)
      expect(transaction.error_message).to eq "Please enter a positive number."
    end

    it "'N/A' if transaction successful?" do
      allow_any_instance_of(Transaction).to receive(:successful?).and_return true
      transaction = Transaction.new(100)
      expect(transaction.error_message).to eq "N/A"
    end
  end


  describe "#valid_number?" do
    it "returns true for 12.4" do
      expect(transaction.valid_number?(12.4)).to be true
    end

    it "returns true for '12.4'" do
      expect(transaction.valid_number?("12.4")).to be true
    end

    it "returns false for 'hello'" do
      expect(transaction.valid_number?("hello")).to be false
    end

    it "returns false for bool" do
      expect(transaction.valid_number?(true)).to be false
    end
  end

  describe "#valid_transaction_amount" do
    let(:transaction) { Transaction.new(10) }

    before do
      allow(transaction).to receive(:valid_number?).and_return true
      allow(transaction).to receive(:within_max_limit?).and_return true
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

  describe "#within_max_limit?" do
    it "returns false for 10000" do
      expect(transaction.within_max_limit?(10_000)).to be false
    end

    it "returns true for 100" do
      expect(transaction.within_max_limit?(100)).to be true
    end
  end

  describe "#convert_to_number" do
    it "converts a string number to a number" do
      expect(transaction.convert_to_number("100")).to eq 100
    end
  end
end
