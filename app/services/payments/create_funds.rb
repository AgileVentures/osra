module Payments
  class CreateFunds

    def self.call(*args)
      new(*args).call
    end

    def call
      @payment.destination = @cashbox
      @payment.save
    end

    private

    attr_reader :cashbox, :payment

    def initialize(cashbox, payment)
      @cashbox = cashbox
      @payment = payment
    end
  end
end
