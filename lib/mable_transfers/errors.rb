module MableTransfers
  class Error < StandardError; end
  class InvalidAccountNumberError < Error; end
  class InvalidAmountError < Error; end
  class DuplicateAccountError < Error; end
  class CsvFormatError < Error; end
end

