RSpec.describe MableTransfers::Transfer do
  it "stores the source, destination and amount" do
    transfer = described_class.new(
      from_account_number: "1111234522226789",
      to_account_number: "1212343433335665",
      amount: "500.00"
    )

    expect(transfer.from_account_number).to eq("1111234522226789")
    expect(transfer.to_account_number).to eq("1212343433335665")
    expect(transfer.amount).to eq(BigDecimal("500.00"))
  end

  it "rejects zero and negative amounts" do
    ["0", "-1.00"].each do |amount|
      expect do
        described_class.new(
          from_account_number: "1111234522226789",
          to_account_number: "1212343433335665",
          amount: amount
        )
      end.to raise_error(MableTransfers::InvalidAmountError)
    end
  end
end

