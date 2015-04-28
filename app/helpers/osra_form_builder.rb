class OsraFormBuilder < ActionView::Helpers::FormBuilder
  def label_for_field(method, text = nil, options = {}, &block)
    required_class = { :class => 'required_field' }

    if presence_validated? method
      options.merge!(required_class) { |_, va, vb| "#{va} #{vb}" }
    end

    @template.label(@object_name, method, text,
                    objectify_options(options), &block)
  end

  private

  def presence_validated?(attr)
    attr_validators = object.class.validators_on(attr).map(&:class)

    (PRESENCE_VALIDATORS & attr_validators).present?
  end
end
