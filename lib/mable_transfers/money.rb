require "bigdecimal"

module MableTransfers
  module Money
    module_function

    def parse(value)
      amount = BigDecimal(value.to_s)
      raise InvalidAmountError, "amount must be finite" unless amount.finite?

      amount
    rescue ArgumentError, TypeError
      raise InvalidAmountError, "amount must be a valid number"
    end

    def non_negative(value)
      amount = parse(value)
      raise InvalidAmountError, "amount cannot be negative" if amount.negative?

      amount
    end

    def positive(value)
      amount = parse(value)
      raise InvalidAmountError, "amount must be greater than zero" unless amount.positive?

      amount
    end

    def format(value)
      whole, fraction = value.round(2).to_s("F").split(".", 2)
      "#{whole}.#{fraction.to_s.ljust(2, "0")[0, 2]}"
    end
  end
end

