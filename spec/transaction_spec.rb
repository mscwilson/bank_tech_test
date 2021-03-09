# frozen_string_literal: true

require "transaction"

describe Transaction do
  let(:transaction) { Transaction.new(DEFAULT_TRANSACTION_AMOUNT) }

  describe "has instance variables" do
    it "stores the amount" do
      expect(transaction.amount).to eq DEFAULT_TRANSACTION_AMOUNT
    end

    it "allows use of string number inputs" do
      allow_any_instance_of(Transaction).to receive(:convert_to_number).and_return DEFAULT_TRANSACTION_AMOUNT
      transaction = Transaction.new(DEFAULT_TRANSACTION_AMOUNT.to_s)
      expect(transaction.amount).to eq DEFAULT_TRANSACTION_AMOUNT
    end

    it "stores the date" do
      allow(Time).to receive(:now).and_return("14/01/2012")
      expect(transaction.date).to eq "14/01/2012"
    end

    it "shows the new balance post transaction" do
      allow_any_instance_of(Transaction).to receive(:successful?).and_return true
      allow_any_instance_of(Transaction).to receive(:calculate_new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
      expect(transaction.new_balance).to eq DEFAULT_TRANSACTION_AMOUNT
    end
  end

  describe "#successful?" do
    before do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return true
      allow_any_instance_of(Transaction).to receive(:within_max_limit?).and_return true
    end

    it "true if valid_transaction_amount? is true" do
      expect(transaction.successful?).to be true
    end

    it "false if within_max_limit? is false" do
      allow_any_instance_of(Transaction).to receive(:within_max_limit?).and_return false
      expect(transaction.successful?).to be false
    end

    it "false if valid_transaction_amount? is false" do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return false
      expect(transaction.successful?).to be false
    end
  end

  describe "#error_message" do
    it "'unable to process large amount' if within_max_limit? false" do
      allow_any_instance_of(Transaction).to receive(:within_max_limit?).and_return false
      expect(transaction.error_message).to eq "Unable to process large deposit. Please speak to your bank manager."
    end

    it "'enter a positive number' if valid_transaction_amount? false" do
      allow_any_instance_of(Transaction).to receive(:valid_transaction_amount?).and_return false
      expect(transaction.error_message).to eq "Please enter a positive number."
    end

    it "'N/A' if transaction successful?" do
      allow_any_instance_of(Transaction).to receive(:successful?).and_return true
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
    before do
      allow(transaction).to receive(:valid_number?).and_return true
      allow(transaction).to receive(:within_max_limit?).and_return true
    end

    it "returns true for 100" do
      expect(transaction.valid_transaction_amount?(DEFAULT_TRANSACTION_AMOUNT)).to be true
    end

    it "returns false for 0" do
      expect(transaction.valid_transaction_amount?(0)).to be false
    end

    it "returns false for -100" do
      expect(transaction.valid_transaction_amount?(-DEFAULT_TRANSACTION_AMOUNT)).to be false
    end
  end

  describe "#within_max_limit?" do
    it "returns false for 10 000" do
      expect(transaction.within_max_limit?(Transaction::MAXIMUM_LIMIT)).to be false
    end

    it "returns true for 100" do
      expect(transaction.within_max_limit?(DEFAULT_TRANSACTION_AMOUNT)).to be true
    end
  end

  describe "#convert_to_number" do
    it "converts a string number to a number" do
      expect(transaction.convert_to_number(DEFAULT_TRANSACTION_AMOUNT.to_s)).to eq DEFAULT_TRANSACTION_AMOUNT
    end
  end

  describe "#calculate_new_balance" do
    it "adds current balance and transaction amount" do
      expect(transaction.calculate_new_balance).to eq DEFAULT_TRANSACTION_AMOUNT
    end
  end
end
