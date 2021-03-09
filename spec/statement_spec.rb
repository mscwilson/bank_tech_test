require "statement"

describe Statement do

  let(:statement) { Statement.new([]) }

  describe "#render_single_transaction" do

    it "returns the correct string for a deposit" do
      @fake_deposit = double(:deposit)
      allow(@fake_deposit).to receive(:date).and_return Time.now
      allow(@fake_deposit).to receive(:amount).and_return 100
      allow(@fake_deposit).to receive(:new_balance).and_return 100
      expected = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
      expect(statement.render_single_transaction(@fake_deposit)).to eq expected
    end
  end




    #   it "prints details of a deposit" do
    #   account.deposit(100)
    #   transaction = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
    #   expect { account.print_statement }.to output(statement_header + transaction + "\n").to_stdout
    # end

    # it "shows the balance at the time of transaction on statement" do
    #   account.deposit(100)
    #   account.deposit(100)

    #   transaction_str1 = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 200.00\n"
    #   transaction_str2 = "#{Time.now.strftime('%d/%m/%Y')} || 100.00 || || 100.00"
    #   full_statement = statement_header + transaction_str1 + transaction_str2 + "\n"

    #   expect { account.print_statement }.to output(full_statement).to_stdout
    # end

    # xit "prints details of a withdrawal" do
    #   account.deposit(1000)
    #   account.withdraw(500)

    #   transaction_str1 = "#{Time.now.strftime('%d/%m/%Y')} || || 500.00 || 500.00\n"
    #   transaction_str2 = "#{Time.now.strftime('%d/%m/%Y')} || 1000.00 || || 1000.00"
    #   full_statement = statement_header + transaction_str1 + transaction_str2 + "\n"

    #   expect { account.print_statement }.to output(full_statement).to_stdout
    # end

    # it "says 'No transactions' if appropriate" do
    #   expect { account.print_statement }.to output("No transactions to show.\n").to_stdout
    # end

    # it "prints two decimal places" do
    #   account.deposit(100.34922)
    #   full_statement = statement_header + "#{Time.now.strftime('%d/%m/%Y')} || 100.35 || || 100.35"
    #   expect { account.print_statement }.to output(full_statement + "\n").to_stdout
    # end

end
