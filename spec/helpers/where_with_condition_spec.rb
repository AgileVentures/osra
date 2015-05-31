require 'rails_helper'

RSpec.describe WhereWithCondition, :type => :helper do
  describe ".where_with_conditions method" do
    class TestClass
      include WhereWithCondition

      def where(q)
      end
    end

    let(:test_instance) {TestClass.new}
    let(:sponsor_active_relation_instance_double) {instance_double Sponsor::ActiveRecord_Relation}
    let(:orphan_active_relation_instance_double) {instance_double Orphan::ActiveRecord_Relation}

    it "method should exist" do
      expect(TestClass.instance_methods.include? :where_with_conditions).to be true
    end

    it "should return a Sponsor ActiveRecord_Relation when conditions are met" do
      expect(test_instance).to receive(:where).and_return(sponsor_active_relation_instance_double)

      expect( test_instance.send(:where_with_conditions, [], {conditions: [true], join: nil}) ).to be sponsor_active_relation_instance_double
    end

    it "should return an Orphan ActiveRecord_Relation when conditions are met" do
      expect(test_instance).to receive(:where).and_return(orphan_active_relation_instance_double)

      expect( test_instance.send(:where_with_conditions, [], {conditions: [true], join: nil}) ).to be orphan_active_relation_instance_double
    end

    it "should return a Sponsor ActiveRecord_Relation when conditions are not met" do
      expect(test_instance).to receive(:where).and_return(sponsor_active_relation_instance_double)

      expect( test_instance.send(:where_with_conditions, [], {conditions: [false], join: nil}) ).to be sponsor_active_relation_instance_double
    end

    it "should return an Orphan ActiveRecord_Relation when conditions are not met" do
      expect(test_instance).to receive(:where).and_return(orphan_active_relation_instance_double)

      expect( test_instance.send(:where_with_conditions, [], {conditions: [false], join: nil}) ).to be orphan_active_relation_instance_double
    end
  end
end
