module Payments
  class CreateFunds

    def self.call(*args)
      new(*args).call
    end

    def call
      if @payment.valid?
        @payment.destination = @cashbox
        @payment.save
      end
    end

    private

    attr_reader :cashbox, :payment

    def initialize(cashbox, amount, payment_builder = Payment)
      @cashbox = cashbox
      @payment = payment_builder.new(amount: amount)
    end
  end
end
