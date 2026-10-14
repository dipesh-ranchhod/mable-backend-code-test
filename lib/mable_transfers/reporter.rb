module MableTransfers
  class Reporter
    def initialize(output: $stdout)
      @output = output
    end

    def transfer(result, number:)
      transfer = result.transfer
      status = result.accepted? ? "ACCEPTED" : "REJECTED"

      @output.puts(
        "#{status} transfer #{number}: " \
        "#{transfer.from_account_number} -> #{transfer.to_account_number} " \
        "$#{Money.format(transfer.amount)}"
      )
      @output.puts("  Reason: #{result.message}") unless result.accepted?
    end

    def balances(accounts)
      @output.puts("\nFinal balances:")
      accounts.each_value do |account|
        @output.puts("#{account.number},#{Money.format(account.balance)}")
      end
    end
  end
end

