# frozen_string_literal: true

require "withdrawal"

describe Withdrawal do
  let(:withdrawal) { Withdrawal.new(100) }

  describe "#amount_more_than_balance?" do
    it "checks if this is true" do
      expect(withdrawal.amount_more_than_balance?).to be true
    end
  end

  describe "#calculate_new_balance" do
    it "adds current balance and withdrawal amount" do
      expect(withdrawal.calculate_new_balance).to eq(-100)
    end
  end

  describe "#error_message" do
    it "'Insufficient funds.' if amount_more_than_balance?" do
      allow_any_instance_of(Withdrawal).to receive(:amount_more_than_balance?).and_return true
      expect(withdrawal.error_message).to eq "Insufficient funds."
    end
  end

  describe "#successful?" do
    it "true if valid_withdrawal_amount? is true" do
      allow_any_instance_of(Withdrawal).to receive(:valid_transaction_amount?).and_return true
      allow_any_instance_of(Withdrawal).to receive(:within_max_limit?).and_return true
      allow_any_instance_of(Withdrawal).to receive(:amount_more_than_balance?).and_return false
      withdrawal = Withdrawal.new(100)
      expect(withdrawal.successful?).to be true
    end

    it "false if within_max_limit? is false" do
      allow_any_instance_of(Withdrawal).to receive(:valid_transaction_amount?).and_return true
      allow_any_instance_of(Withdrawal).to receive(:within_max_limit?).and_return false
      withdrawal = Withdrawal.new(100)
      expect(withdrawal.successful?).to be false
    end

    it "false if amount_more_than_balance?" do
      allow_any_instance_of(Withdrawal).to receive(:valid_transaction_amount?).and_return true
      allow_any_instance_of(Withdrawal).to receive(:within_max_limit?).and_return false
      allow_any_instance_of(Withdrawal).to receive(:amount_more_than_balance?).and_return true
      withdrawal = Withdrawal.new(100)
      expect(withdrawal.successful?).to be false
    end
  end

  describe "#within_max_limit" do
    it "uses the withdrawal max limit" do
      expect(withdrawal.within_max_limit?(3000)).to be false
    end
  end
end
