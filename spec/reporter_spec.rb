RSpec.describe MableTransfers::Reporter do
  let(:output) { StringIO.new }
  let(:reporter) { described_class.new(output: output) }
  let(:transfer) do
    MableTransfers::Transfer.new(
      from_account_number: "1111234522226789",
      to_account_number: "1212343433335665",
      amount: "500.00"
    )
  end

  it "reports an accepted transfer" do
    reporter.transfer(MableTransfers::TransferResult.accepted(transfer), number: 1)

    expect(output.string).to include("ACCEPTED transfer 1")
    expect(output.string).to include("$500.00")
  end

  it "reports the reason for a rejected transfer" do
    result = MableTransfers::TransferResult.rejected(transfer, "insufficient funds")

    reporter.transfer(result, number: 1)

    expect(output.string).to include("REJECTED transfer 1")
    expect(output.string).to include("Reason: insufficient funds")
  end
end

