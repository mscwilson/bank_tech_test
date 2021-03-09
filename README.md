## Bank tech test

Makers Academy week 10

### Specification
#### Requirements

* You should be able to interact with your code via a REPL like IRB or the JavaScript console. (You don't need to implement a command line interface that takes input from STDIN.)
* Deposits, withdrawal.
* Account statement (date, amount, balance) printing.
* Data can be kept in memory (it doesn't need to be stored to a database or anything).

#### Acceptance criteria

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
  
### Planning

Bank account class?

current_balance
transactions_list

deposit() - amount, date, balance_immediately_afterwards - hash?
withdraw() - amount, date, balance_immediately_afterwards

print_statement() - reverse order of transactions


Edge cases:
no overdraft - can't withdraw more than in the account
no transactions before bank statement print
deposit or withdraw negative numbers
deposit or withdraw 0 pounds
print 2dp
check amount given is actually a number
maybe allow string num amounts?

float input - actually store as pence? what to do if given more than 2dp?
dates - in future/wrong format - allow strings to be given
very large amounts deposited £10 000 withdraw £2500

