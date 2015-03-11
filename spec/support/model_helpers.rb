# use like this:
# it { is_expected.to have_validation ValidDatePresenceValidator,
#                                     :on => :start_date,
#                                     :options => [:allow_blank, :allow_nil]
#                                     }
RSpec::Matchers.define :have_validation do |validator, params|
  match do |model|
    my_validators = model.class.validators.select { |v| v.class == validator and v.attributes.include? params[:on] }
    my_validators = validators.select { |v| params[:options].all? { |po| v.options.any? { |vo| vo == po } } } if params[:options]
    my_validators.size == 1
  end

  failure_message do |model|
    message = "expected that #{model} would have validation #{validator} on '#{params[:on]}' field"
    message = message + " and options '#{params[:options]}'" if params[:options]
    message
  end

  failure_message_when_negated do |model|
    message = "expected that #{model} would NOT have validation #{validator} on '#{params[:on]}' field"
    message = message + " and options '#{params[:options]}'" if params[:options]
    message
  end
end
