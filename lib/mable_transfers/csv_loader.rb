require "csv"

module MableTransfers
  class CsvLoader
    class << self
      def accounts(path)
        load_rows(path, expected_columns: 2) do |row|
          Account.new(number: row[0], balance: row[1])
        end
      end

      def transfers(path)
        load_rows(path, expected_columns: 3) do |row|
          Transfer.new(
            from_account_number: row[0],
            to_account_number: row[1],
            amount: row[2]
          )
        end
      end

      private

      def load_rows(path, expected_columns:)
        CSV.foreach(path, skip_blanks: true).with_index(1).map do |row, row_number|
          validate_column_count!(row, expected_columns)
          yield row
        rescue MableTransfers::Error => e
          raise CsvFormatError, "#{path}: row #{row_number}: #{e.message}"
        end
      rescue Errno::ENOENT
        raise CsvFormatError, "file not found: #{path}"
      rescue CSV::MalformedCSVError => e
        raise CsvFormatError, "invalid CSV in #{path}: #{e.message}"
      end

      def validate_column_count!(row, expected_columns)
        return if row.length == expected_columns

        raise CsvFormatError,
              "expected #{expected_columns} columns, found #{row.length}"
      end
    end
  end
end

