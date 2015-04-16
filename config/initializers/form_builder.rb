module RailsExtensions
  module FormBuilder
    module RequiredFields
      def label_for_field(method, text = nil, options = {}, &block)
        required_class = { :class => 'required_field' }

        if presence_validated? method
          options.merge!(required_class) { |_, va, vb| "#{va} #{vb}" }
        end

        self.label(method, text, options, &block)
      end

      private

      def presence_validated?(attr)
        attr_validators = object.class.validators_on(attr).map(&:class)

        (PRESENCE_VALIDATORS & attr_validators).present?
      end
    end
  end
end
