# use like this:
# it { is_expected.to have_validation :valid_date_presence,
#                                     :on => :start_date,
#                                     :options => [:allow_blank, :allow_nil]
#                                     }
RSpec::Matchers.define :have_validation do |validator, params|
  validator_class = eval(validator.to_s.camelize + "Validator")

  match do |model|
    @_validators = model.class.validators.select { |v| (v.class == validator_class) && (v.attributes.include? params[:on]) }
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

  def validator_receives_correct_options? options
    return true unless options
    options.all? { |o| @_validators.first.options.has_key?(o) }
  end
end
