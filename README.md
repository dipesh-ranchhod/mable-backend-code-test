# Mable Back End Code Challenge

A small Ruby command-line application that loads account balances, processes a
day of transfers in order, rejects transfers that would overdraw an account,
and reports the final balances.

## Requirements

- Ruby 3.2 or later
- Bundler

No Rails application or database is required.

## Setup

```bash
bundle install
```

## Run the application

```bash
bundle exec ruby bin/process_transfers \
  spec/fixtures/mable_account_balances.csv \
  spec/fixtures/mable_transactions.csv
```

The program prints an accepted or rejected result for each transfer, followed
by the final account balances.

## Run the tests

```bash
bundle exec rake
```

or:

```bash
bundle exec rspec
```

## Design

- `Account` owns balance behaviour and prevents an overdraft.
- `Transfer` represents a validated request to move a positive amount.
- `Ledger` locates accounts and coordinates an atomic in-memory transfer.
- `CsvLoader` separates file parsing from domain behaviour and reports the row
  containing invalid input.
- `TransferResult` represents an accepted or rejected business outcome.
- `Reporter` keeps console formatting outside the domain models.

Account numbers are stored as strings so leading zeroes are preserved.
`BigDecimal` is used instead of floating-point values to avoid monetary
rounding errors.

## Assumptions

- Both CSV files have no header row, matching the supplied examples.
- Accounts are identified by exactly 16 digits.
- Opening balances must be zero or greater.
- Transfer amounts must be greater than zero.
- Transfers are processed in file order.
- A transfer with an unknown account or insufficient funds is rejected, and
  processing continues with the next transfer.
- All values are in a single currency.

## Production considerations

For a persistent or concurrent system, the debit and credit would be performed
inside a database transaction with account locking. I would also add transfer
identifiers for idempotency, structured audit events, currency support, and
operational monitoring.

