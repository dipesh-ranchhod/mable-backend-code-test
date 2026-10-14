module MableTransfers
  class Ledger
    attr_reader :accounts

    def initialize(accounts)
      @accounts = {}
      accounts.each { |account| add_account(account) }
    end

    def apply(transfer)
      source = @accounts[transfer.from_account_number]
      destination = @accounts[transfer.to_account_number]

      return TransferResult.rejected(transfer, "source account not found") unless source
      return TransferResult.rejected(transfer, "destination account not found") unless destination
      return TransferResult.rejected(transfer, "insufficient funds") unless source.sufficient_funds?(transfer.amount)

      source.debit(transfer.amount)
      destination.credit(transfer.amount)

      TransferResult.accepted(transfer)
    end

    private

    def add_account(account)
      if @accounts.key?(account.number)
        raise DuplicateAccountError, "duplicate account number #{account.number}"
      end

      @accounts[account.number] = account
    end
  end
end

