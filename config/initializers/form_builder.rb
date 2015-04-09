class ActionView::Helpers::FormBuilder

  def label_for_field(method, text = nil, options = {}, &block)
    if presence_validated? method
      options.merge!({ :class => 'required_field' })
    end

    self.label(method, text, options, &block)
  end

  private

  def presence_validated?(attr)
    attr_validators = object.class.validators_on(attr).map(&:class)

    (PRESENCE_VALIDATORS & attr_validators).present?
  end
end
