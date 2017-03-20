module Payments
  class MakePayment

    def self.call(*args)
      new(*args).call
    end

    def call
      payment = payment_builder.new(source: source,
                                    destination: destination,
                                    amount: amount)
      payment.save
    end

    private

    attr_reader :source, :destination, :amount, :payment_builder

    def initialize(source:, destination:, amount:, payment_builder: Payment)
      @source = source
      @destination = destination
      @amount = amount
      @payment_builder = payment_builder
    end

  end
end
