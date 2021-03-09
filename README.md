## Bank Account Tech Test

A command line bank account app, in Ruby.

### Description

This project formed part of the [Makers Academy](https://makers.tech) coding bootcamp. The goal was to produce the best code possible, as if it were a real tech test for an interview.  

No further development is planned.  

This was the provided specification:
**Requirements**  
* You should be able to interact with your code via a REPL like IRB or the JavaScript console. (You don't need to implement a command line interface that takes input from STDIN.)
* Deposits, withdrawal.
* Account statement (date, amount, balance) printing.
* Data can be kept in memory (it doesn't need to be stored to a database or anything).

**Acceptance criteria**  
Given a client makes a deposit of 1000 on 10-01-2012
And a deposit of 2000 on 13-01-2012
And a withdrawal of 500 on 14-01-2012
When she prints her bank statement
Then she would see

```
date || credit || debit || balance
14/01/2012 || || 500.00 || 2500.00
13/01/2012 || 2000.00 || || 3000.00
10/01/2012 || 1000.00 || || 1000.00
```
  
![using the app](public/deposits_and_withdrawals.png)
![seeing error messages](public/error_messages.png)  
  
### Installation and Usage

This project was written using Ruby v3.0.0.

**Installation**
* Make sure Ruby and Bundler are installed on your machine.
* Clone this git repo, and navigate to the cloned folder.
* Run `bundle` to install gems.

**Running tests**
* Run `rspec` to run the test suite.

**Using the app**
* Run `irb -r ./lib/bank_account` to run the irb Ruby REPL with the main bank_account.rb file loaded in.
* Create a new bank account by entering `account = BankAccount.new`.
* Deposit money with eg `account.deposit(10)` to deposit £10.
* Withdraw money using eg `account.withdraw(10)`.
* Get a bank statement by running `account.print_statement`.

### Technical details

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)


This project has 100% test coverage, according to the SimpleCov gem. Feature/integration and unit tests are included, written in Rspec.  

* The main class is BankAccount, which maintains the current balance and a list of transactions.
* Deposit and Withdrawal are subclasses of Transaction.
* In fact Deposit is effectively Transaction with a more appropriate name. I could have gone straight for Deposit and have Withdrawal inherit from there, but that seemed weird. This way also keeps the door open for adding other types of transactions in the future, such as Transfer.
* Transactions store the amount of money involved, the date, and the balance after the transaction occurs. They also contain information about whether the transaction is successful or if there was an error, eg an invalid input amount.
* Withdrawal has additional methods to prevent going overdrawn, as well as making sure that the amount is subtracted rather than added to the balance.
* To be more like a real bank, there's a limit on depositing or withdrawing too much in one go.
* To improve user experience, it's possible to enter amounts as strings as well as numbers. Of course, decimal amounts are also fine, not just whole integer £s.
* The bank statement and errors are printed directly out into the console for the user to see, not returned from methods.  

### Known issues
* I'm using Floats for the amounts. This isn't ideal for money because of how rounding works. A quick fix would be to store all the money as Integers in pence, ie x100. And also prevent users from entering more than 2 decimal places for transaction amount.
* Not really an issue because it wasn't in the specification anyway, but actually in real banks the limit on depositing or withdrawing too much is capped daily, rather than per transaction. That's not a trivial feature to add as the Transactions don't currently know anything about transaction history.






Edge cases:
no overdraft - can't withdraw more than in the account
no transactions before bank statement print
deposit or withdraw negative numbers
deposit or withdraw 0 pounds
print 2dp
check amount given is actually a number
maybe allow string num amounts?
very large amounts deposited £10 000 withdraw £2500
NB skip unsuccessful transactions in printing
NB magic numbers in code
float input - actually store as pence? what to do if given more than 2dp?

Magic nums in specs

NB fix inheritance of Transaction within_max_limit?

