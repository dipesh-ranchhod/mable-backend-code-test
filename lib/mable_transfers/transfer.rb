module MableTransfers
  class Transfer
    attr_reader :from_account_number, :to_account_number, :amount

    def initialize(from_account_number:, to_account_number:, amount:)
      @from_account_number = validate_account_number(from_account_number, "source")
      @to_account_number = validate_account_number(to_account_number, "destination")
      @amount = Money.positive(amount)
    end

    private

    def validate_account_number(value, label)
      number = value.to_s.strip
      return number if Account::NUMBER_PATTERN.match?(number)

      raise InvalidAccountNumberError,
            "#{label} account number must contain exactly 16 digits"
    end
  end
end

