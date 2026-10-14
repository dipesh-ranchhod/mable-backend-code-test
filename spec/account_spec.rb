RSpec.describe MableTransfers::Account do
  subject(:account) do
    described_class.new(number: "1111234522226789", balance: "5000.00")
  end

  describe "#debit" do
    it "decreases the balance when funds are available" do
      expect(account.debit("500.00")).to be(true)
      expect(account.balance).to eq(BigDecimal("4500.00"))
    end

    it "does not change the balance when funds are insufficient" do
      expect(account.debit("5000.01")).to be(false)
      expect(account.balance).to eq(BigDecimal("5000.00"))
    end
  end

  describe "#credit" do
    it "increases the balance" do
      account.credit("320.50")
      expect(account.balance).to eq(BigDecimal("5320.50"))
    end
  end

  describe "validation" do
    it "rejects an account number that is not exactly 16 digits" do
      expect do
        described_class.new(number: "1234", balance: "10.00")
      end.to raise_error(MableTransfers::InvalidAccountNumberError)
    end

    it "rejects a negative opening balance" do
      expect do
        described_class.new(number: "1111234522226789", balance: "-0.01")
      end.to raise_error(MableTransfers::InvalidAmountError)
    end
  end
end

