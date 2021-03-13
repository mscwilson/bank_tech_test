# frozen_string_literal: true

require "transaction"

describe Transaction do
  let(:transaction) { Transaction.new(DEFAULT_TRANSACTION_AMOUNT) }

  describe "has instance variables" do
    it "stores the amount" do
      expect(transaction.amount).to eq DEFAULT_TRANSACTION_AMOUNT
    end

    it "stores the date" do
      allow(Time).to receive(:now).and_return("14/01/2012")
      expect(transaction.date).to eq "14/01/2012"
    end

    it "shows the new balance post transaction" do
      allow(transaction).to receive(:successful?).and_return true
      allow(transaction).to receive(:calculate_new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
      expect(transaction.new_balance).to eq DEFAULT_TRANSACTION_AMOUNT
    end
  end

  describe "new_balance" do
    it "same as starting balance if unsuccessful" do
      transaction = Transaction.new(-DEFAULT_TRANSACTION_AMOUNT)
      expect(transaction.new_balance).to eq 0
    end

    it "increased compared to starting balance for a deposit" do
      transaction = Transaction.new(DEFAULT_TRANSACTION_AMOUNT)
      expect(transaction.new_balance).to eq DEFAULT_TRANSACTION_AMOUNT
    end

    it "decreased compared to starting balance for a withdrawal" do
      limit = Transaction::MAXIMUM_WITHDRAWAL_LIMIT
      transaction = Transaction.new(-DEFAULT_TRANSACTION_AMOUNT, limit, "withdrawal")
      expect(transaction.new_balance).to eq(limit - DEFAULT_TRANSACTION_AMOUNT)
    end
  end

  describe "#successful?" do
    describe "deposits false if" do
      it "amount given is 0" do
        transaction = Transaction.new(0)
        expect(transaction.successful?).to be false
      end

      it "deposit but given a negative number" do
        transaction = Transaction.new(-DEFAULT_TRANSACTION_AMOUNT)
        expect(transaction.successful?).to be false
      end

      it "deposit but outside max range" do
        transaction = Transaction.new(Transaction::MAXIMUM_DEPOSIT_LIMIT)
        expect(transaction.successful?).to be false
      end
    end

    describe "withdrawals also false if" do
      it "more than current balance" do
        transaction = Transaction.new(-(DEFAULT_TRANSACTION_AMOUNT + 1), DEFAULT_TRANSACTION_AMOUNT, "withdrawal")
        expect(transaction.successful?).to be false
      end

      it "outside max range" do
        limit = Transaction::MAXIMUM_WITHDRAWAL_LIMIT
        transaction = Transaction.new(limit, limit + 1, "withdrawal")
        expect(transaction.successful?).to be false
      end
    end
  end

  describe "error" do
    it "N/A if no problem with transaction" do
      transaction = Transaction.new(DEFAULT_TRANSACTION_AMOUNT)
      expect(transaction.error).to eq "N/A"
    end

    it "'enter a positive number' if given 0" do
      transaction = Transaction.new(0)
      expect(transaction.error).to eq "Please enter a positive number."
    end

    it "'enter a positive number' if given a negative deposit amount" do
      transaction = Transaction.new(-DEFAULT_TRANSACTION_AMOUNT)
      expect(transaction.error).to eq "Please enter a positive number."
    end

    it "'Unable to process' deposit outside max range" do
      transaction = Transaction.new(Transaction::MAXIMUM_DEPOSIT_LIMIT)
      expect(transaction.error).to eq "Unable to process large request. "\
                                      "Please speak to your bank manager."
    end

    it "'insufficient funds' if withdrawal more than balance" do
      transaction = Transaction.new(-DEFAULT_TRANSACTION_AMOUNT, 0, "withdrawal")
      expect(transaction.error).to eq "Insufficient funds."
    end
  end
end
