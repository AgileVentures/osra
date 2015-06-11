require 'rails_helper'

RSpec.describe WhereWithCondition, :type => :helper do
  describe ".where_with_conditions method" do

    class TestClass
      include ActiveRecord::Querying
      include WhereWithCondition
    end

    let(:test_instance) {TestClass.new}
    let(:active_relation_instance_double) {instance_double Sponsor::ActiveRecord_Relation}

    it "method should exist" do
      expect(TestClass.instance_methods.include? :where_with_conditions).to be true
    end

    context "when conditions are met" do
      it "should call .where with a query message and return an ActiveRecord_Relation" do
        expect(test_instance).to receive_message_chain(:joins, :where).with("query").and_return(active_relation_instance_double)

        expect( test_instance.send(:where_with_conditions, "query", {conditions: [true]}) ).to be active_relation_instance_double
      end

      it "should join relation models when specified" do
        expect(test_instance).to receive(:joins,).with("related_model").and_return(test_instance)
        allow(test_instance).to receive(:where).and_return(active_relation_instance_double)

        test_instance.send(:where_with_conditions, [], {conditions: [true], join: "related_model"})
      end
    end

    context "when conditions are NOT met" do
      it "should call .where with nil and return ActiveRecord_Relation" do
        expect(test_instance).to receive(:where).with(nil).and_return(active_relation_instance_double)

        expect( test_instance.send(:where_with_conditions, [], {conditions: [false]}) ).to be active_relation_instance_double
      end
    end
  end
end