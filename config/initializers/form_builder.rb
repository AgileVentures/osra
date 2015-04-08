class ActionView::Helpers::FormBuilder

  def label_for_field(method, text = nil, options = {}, &block)
    if presence_validated? method
      options.merge!({ :class => 'required_field' })
    end

    self.label(method, text, options, &block)
  end

  def presence_validated?(attr)
    presence_validators = [ActiveRecord::Validations::PresenceValidator,
                           ValidDatePresenceValidator]

    attr_validators = object.class.validators_on(attr).map(&:class)

    (presence_validators & attr_validators).present?
  end
end
