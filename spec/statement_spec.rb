# frozen_string_literal: true

require "statement"

describe Statement do
  before do
    @fake_time = double(:time)
    allow(@fake_time).to receive(:strftime).and_return("13/03/21")

    @fake_transaction = double(:transaction)
    allow(@fake_transaction).to receive(:date).and_return @fake_time
    allow(@fake_transaction).to receive(:amount).and_return DEFAULT_TRANSACTION_AMOUNT
    allow(@fake_transaction).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
    allow(@fake_transaction).to receive(:successful?).and_return true

    @statement = Statement.new([@fake_transaction])
  end

  describe "#final_output" do
    it "returns an error message if there weren't any transactions" do
      statement = Statement.new([])
      expect(statement.final_output).to eq "No transactions to show."
    end

    it "has header and appropriate transaction info for a deposit" do
      expected_info = "13/03/21 || 100.00 || || 100.00"
      final_string = "#{Statement::HEADER}\n#{expected_info}"
      expect(@statement.final_output).to eq final_string
    end

    it "has header and appropriate transaction info for a withdrawal" do
      allow(@fake_transaction).to receive(:amount).and_return(-DEFAULT_TRANSACTION_AMOUNT)
      expected_info = "13/03/21 || || 100.00 || 100.00"
      final_string = "#{Statement::HEADER}\n#{expected_info}"
      expect(@statement.final_output).to eq final_string
    end

    it "uses two decimal places" do
      allow(@fake_transaction).to receive(:amount).and_return 100.348123
      allow(@fake_transaction).to receive(:new_balance).and_return 100.348123
      expected_info = "13/03/21 || 100.35 || || 100.35"
      final_string = "#{Statement::HEADER}\n#{expected_info}"
      expect(@statement.final_output).to eq final_string
    end

    it "renders all the transactions into strings in reverse order" do
      earlier_fake_time = double(:time)
      allow(earlier_fake_time).to receive(:strftime).and_return("10/03/21")

      earlier_fake_transaction = double(:transaction)
      allow(earlier_fake_transaction).to receive(:date).and_return earlier_fake_time
      allow(earlier_fake_transaction).to receive(:amount).and_return DEFAULT_TRANSACTION_AMOUNT
      allow(earlier_fake_transaction).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
      allow(earlier_fake_transaction).to receive(:successful?).and_return true

      statement = Statement.new([earlier_fake_transaction, @fake_transaction])

      expected_info = "#{Statement::HEADER}\n"\
                      "13/03/21 || 100.00 || || 100.00\n"\
                      "10/03/21 || 100.00 || || 100.00"
      expect(statement.final_output).to eq expected_info
    end

    it "skips unsuccessful transactions" do
      allow(@fake_transaction).to receive(:successful?).and_return false
      expect(@statement.final_output).to eq "No transactions to show."
    end
  end
end
