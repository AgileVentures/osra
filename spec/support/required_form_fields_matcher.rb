RSpec::Matchers.define :mark_required_fields_for do |object_class|

  match do |form|
    @form = form
    @object_class = object_class
    required_attributes = attrs_with_presence_validation
    form_marks_all_fields_for? required_attributes
  end

  failure_message do |form|
    "expected form to mark as required fields for #{fields_with_missing_mark}"
  end

  def attrs_with_presence_validation
    @object_class.new.attributes.keys.select do |attr|
      (@object_class.validators_on(attr).map(&:class) & PRESENCE_VALIDATORS).present?
    end
  end

  def form_marks_all_fields_for?(attributes)
    @fields_marked_required = attributes.inject({}) do |h, attr|
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

    @fields_marked_required.values.all?
  end

  def fields_with_missing_mark
    @fields_marked_required.reject { |_, v| v }.keys.join(', ')
  end
end
