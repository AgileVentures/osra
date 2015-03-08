# use like this:
# it { is_expected.to have_validation :valid_date_presence,
#                                     :on => :start_date,
#                                     :options => {allow_nil: true, allow_blank: true, if: :date_attr}
#                                     }
#checking only for a few of the options is accepted (eg. :options => {if: :date_attr})
RSpec::Matchers.define :have_validation do |validator, params|
  validator_class_name = eval(validator.to_s.camelize + "Validator")

  match do |model|
    model_validators = model.class.validators
    @_validators = model_validators.select do |v|
      (v.class == validator_class_name) && (v.attributes.include? params[:on])
    end
    validator_included_once? && (validator_receives_correct_options? params[:options])
  end

  failure_message do |model|
    message = "expected #{model} to have validation ':#{validator}' on ':#{params[:on]}' field"
    message << " with the options #{params[:options]}" if params[:options]
    message
  end

  failure_message_when_negated do |model|
    message = "expected #{model} to NOT have validation :#{validator} on ':#{params[:on]}' field"
    message << " with the options #{params[:options]}" if params[:options]
    message
  end


  def validator_included_once?
    @_validators.size == 1
  end

  def validator_receives_correct_options? expected_options
    return true unless expected_options

    validators_options = @_validators.first.options
    expected_options.all? do |k,v|
      validators_options.has_key?(k) && validators_options[k] == v
    end
  end

end
