require "tempfile"

RSpec.describe MableTransfers::CsvLoader do
  describe ".accounts" do
    it "loads accounts from a CSV file" do
      accounts = described_class.accounts(fixture("mable_account_balances.csv"))

      expect(accounts.length).to eq(5)
      expect(accounts.first.number).to eq("1111234522226789")
      expect(accounts.first.balance).to eq(BigDecimal("5000.00"))
    end
  end

  describe ".transfers" do
    it "loads transfers from a CSV file" do
      transfers = described_class.transfers(fixture("mable_transactions.csv"))

      expect(transfers.length).to eq(4)
      expect(transfers.first.amount).to eq(BigDecimal("500.00"))
    end
  end

  it "identifies the row containing invalid data" do
    file = Tempfile.new(["invalid-accounts", ".csv"])
    file.write("1111234522226789,100.00\ninvalid,50.00\n")
    file.close

    expect do
      described_class.accounts(file.path)
    end.to raise_error(MableTransfers::CsvFormatError, /row 2/)
  ensure
    file&.unlink
  end

  def fixture(name)
    File.expand_path("fixtures/#{name}", __dir__)
  end
end

