module Payments
  class MakePayment

    def self.call(*args)
      new(*args).call
    end

    def call
      if can_make_payment?(source, amount)
        payment = payment_builder.new(source: source,
                                      destination: destination,
                                      amount: amount)

        if payment.valid?
          payment.save
        else
          {errors: payment.errors.full_messages}
        end
      else
        {errors: "Amount exceeds cashbox amount"}
      end
    end

    private

    attr_reader :source, :destination, :amount, :payment_builder

    def initialize(source:, destination:, amount:, payment_builder: Payment)
      @source = source
      @destination = destination
      @amount = amount
      @payment_builder = payment_builder
    end

    def can_make_payment?(cashbox, amount)
      cashbox.total >= amount
    end
    
  end
end
