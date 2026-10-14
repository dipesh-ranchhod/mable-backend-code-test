RSpec.describe "processing the supplied files" do
  it "calculates the expected final balances" do
    accounts = MableTransfers::CsvLoader.accounts(fixture("mable_account_balances.csv"))
    transfers = MableTransfers::CsvLoader.transfers(fixture("mable_transactions.csv"))
    ledger = MableTransfers::Ledger.new(accounts)

    results = transfers.map { |transfer| ledger.apply(transfer) }

    expect(results).to all(be_accepted)
    expect(formatted_balances(ledger)).to eq(
      "1111234522226789" => "4820.50",
      "1111234522221234" => "9974.40",
      "2222123433331212" => "1550.00",
      "1212343433335665" => "1725.60",
      "3212343433335755" => "48679.50"
    )
  end

  def fixture(name)
    File.expand_path("fixtures/#{name}", __dir__)
  end

  def formatted_balances(ledger)
    ledger.accounts.transform_values do |account|
      MableTransfers::Money.format(account.balance)
    end
  end
end

