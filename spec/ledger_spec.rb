RSpec.describe MableTransfers::Ledger do
  let(:source) do
    MableTransfers::Account.new(number: "1111234522226789", balance: "500.00")
  end
  let(:destination) do
    MableTransfers::Account.new(number: "1212343433335665", balance: "100.00")
  end
  let(:ledger) { described_class.new([source, destination]) }

  def transfer(amount:, from: source.number, to: destination.number)
    MableTransfers::Transfer.new(
      from_account_number: from,
      to_account_number: to,
      amount: amount
    )
  end

  it "moves money between known accounts" do
    result = ledger.apply(transfer(amount: "125.50"))

    expect(result).to be_accepted
    expect(source.balance).to eq(BigDecimal("374.50"))
    expect(destination.balance).to eq(BigDecimal("225.50"))
  end

  it "rejects an overdraft without changing either balance" do
    result = ledger.apply(transfer(amount: "500.01"))

    expect(result).not_to be_accepted
    expect(result.message).to eq("insufficient funds")
    expect(source.balance).to eq(BigDecimal("500.00"))
    expect(destination.balance).to eq(BigDecimal("100.00"))
  end

  it "allows a transfer that leaves the source balance at zero" do
    result = ledger.apply(transfer(amount: "500.00"))

    expect(result).to be_accepted
    expect(source.balance).to eq(BigDecimal("0.00"))
    expect(destination.balance).to eq(BigDecimal("600.00"))
  end

  it "uses the updated balance when processing the next transfer" do
    first_result = ledger.apply(transfer(amount: "450.00"))
    second_result = ledger.apply(transfer(amount: "75.00"))

    expect(first_result).to be_accepted
    expect(second_result).not_to be_accepted
    expect(source.balance).to eq(BigDecimal("50.00"))
    expect(destination.balance).to eq(BigDecimal("550.00"))
  end

  it "rejects a missing source account" do
    result = ledger.apply(transfer(amount: "10.00", from: "9999999999999999"))

    expect(result).not_to be_accepted
    expect(result.message).to eq("source account not found")
    expect(destination.balance).to eq(BigDecimal("100.00"))
  end

  it "rejects a missing destination account without debiting the source" do
    result = ledger.apply(transfer(amount: "10.00", to: "9999999999999999"))

    expect(result).not_to be_accepted
    expect(result.message).to eq("destination account not found")
    expect(source.balance).to eq(BigDecimal("500.00"))
  end

  it "rejects duplicate account numbers" do
    duplicate = MableTransfers::Account.new(
      number: source.number,
      balance: "25.00"
    )

    expect do
      described_class.new([source, duplicate])
    end.to raise_error(MableTransfers::DuplicateAccountError)
  end
end

