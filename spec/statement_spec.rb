# frozen_string_literal: true

require "statement"

describe Statement do
  let(:statement) { Statement.new([1, 2, 3]) }

  describe "#render_single_transaction" do
    before do
      @fake_transaction = double(:deposit)
      allow(@fake_transaction).to receive(:date).and_return Time.now
      allow(@fake_transaction).to receive(:amount).and_return DEFAULT_TRANSACTION_AMOUNT
      allow(@fake_transaction).to receive(:new_balance).and_return DEFAULT_TRANSACTION_AMOUNT
    end

    it "returns the correct string for a deposit" do
      allow(@fake_transaction).to receive(:instance_of?).and_return true
      expected = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      expect(statement.render_single_transaction(@fake_transaction)).to eq expected
    end

    it "returns the correct string for a withdrawal" do
      allow(@fake_transaction).to receive(:instance_of?).and_return false
      expected = "#{Time.now.strftime('%d/%m/%Y')} || || 100.00 || 100.00"
      expect(statement.render_single_transaction(@fake_transaction)).to eq expected
    end
  end

  describe "#transactions_to_strings" do
    it "renders all the transactions into strings in reverse order" do
      allow(statement).to receive(:render_single_transaction).and_return("hello", "world", "!")
      expect(statement.transactions_to_strings).to eq [Statement::HEADER, "hello", "world", "!"]
    end
  end

  describe "#transactions?" do
    it "is true if given a list with things in" do
      expect(statement.transactions?).to be true
    end

    it "is false if given an empty list" do
      statement = Statement.new([])
      expect(statement.transactions?).to be false
    end
  end

  describe "#final_output" do
    it "returns an error message if there weren't any transactions" do
      allow(statement).to receive(:transactions?).and_return false
      expect(statement.final_output).to eq "No transactions to show."
    end

    it "has header and appropriate transaction info" do
      expected_info = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      final_string = "#{Statement::HEADER}\n#{expected_info}"
      allow(statement).to receive(:transactions?).and_return true
      allow(statement).to receive(:transactions_to_strings).and_return [Statement::HEADER, expected_info]
      expect(statement.final_output).to eq final_string
    end
  end

  xit "prints two decimal places" do
    account.deposit(100.34922)
    full_statement = statement_header + "#{Time.now.strftime('%d/%m/%Y')} || 100.35 || || 100.35"
    expect { account.print_statement }.to output(full_statement + "\n").to_stdout
  end
end
