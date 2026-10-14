module MableTransfers
  class Account
    NUMBER_PATTERN = /\A\d{16}\z/

    attr_reader :number, :balance

    def initialize(number:, balance:)
      @number = validate_number(number)
      @balance = Money.non_negative(balance)
    end

    def sufficient_funds?(amount)
      @balance >= Money.positive(amount)
    end

    def debit(amount)
      debit_amount = Money.positive(amount)
      return false if debit_amount > @balance

      @balance -= debit_amount
      true
    end

    def credit(amount)
      @balance += Money.positive(amount)
    end

    private

    def validate_number(value)
      number = value.to_s.strip
      return number if NUMBER_PATTERN.match?(number)

      raise InvalidAccountNumberError, "account number must contain exactly 16 digits"
    end
  end
end

