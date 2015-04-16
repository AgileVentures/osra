require 'rails_helper'

RSpec.describe 'optional_form_fields_matcher' do
  let(:test_class) do
    Class.new do
      include ActiveRecord::Validations

      attr_accessor :presence_validated_attr,
        :non_validated_attr,
        :date_validated_attr

      validates :validated_attr, presence: true
      validates :date_validated_attr, valid_date_presence: true
      validates :non_validated_attr, inclusion: { in: [0, 1] }

      def attributes
        {
          :validated_attr => nil,
          :date_validated_attr => nil,
          :non_validated_attr => nil
        }
      end

      def self.name
        "TestClass"
      end
    end
  end

  describe 'required_fields matcher' do
    specify 'works when form is correct' do
      correct_form = <<-END
        <label class="required_field" for="test_class_validated_attr"></label>
        <label class="another_class" for="test_class_non_validated_attr"></label>
        <label class="required_field" for="test_class_date_validated_attr"></label>
      END

      expect(correct_form).not_to mark_optional_fields_for test_class
    end

    specify 'works when form is incorrect' do
      incorrect_form = <<-END
        <label class="required_field" for="test_class_validated_attr"></label>
        <label class="required_field" for="test_class_non_validated_attr"></label>
        <label class="another_class" for="test_class_date_validated_attr"></label>
      END

      expect(incorrect_form).to mark_optional_fields_for test_class
    end
  end
end
