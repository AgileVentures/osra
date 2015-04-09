RSpec::Matchers.define :mark_optional_fields_for do |object_class|

  match do |form|
    @form = form
    @object_class = object_class
    optional_attributes = attrs_without_presence_validation
    form_does_not_mark_all_fields_for? optional_attributes
  end

  failure_message_when_negated do |form|
    "expected form not to mark as required fields for #{fields_wrongly_marked}"
  end

  def attrs_without_presence_validation
    @object_class.new.attributes.keys.reject do |attr|
      (@object_class.validators_on(attr).map(&:class) & PRESENCE_VALIDATORS).present?
    end
  end

  def form_does_not_mark_all_fields_for?(attributes)
    @fields_not_marked_required = attributes.inject({}) do |h, attr|
      required_label = %r{
        label
        \s
        class=\"required_field\"
        \s
        for=\"#{@object_class.name.underscore}_#{attr}\"
      }x

      h[attr] = @form =~ required_label
      h
    end

    @fields_not_marked_required.values.any?
  end

  def fields_wrongly_marked
    @fields_not_marked_required.reject { |_, v| v.nil? }.keys.join(', ')
  end
end

