module MableTransfers
  class TransferResult
    attr_reader :transfer, :message

    def self.accepted(transfer)
      new(transfer: transfer, accepted: true, message: "transfer completed")
    end

    def self.rejected(transfer, message)
      new(transfer: transfer, accepted: false, message: message)
    end

    def initialize(transfer:, accepted:, message:)
      @transfer = transfer
      @accepted = accepted
      @message = message
    end

    def accepted?
      @accepted
    end
  end
end

