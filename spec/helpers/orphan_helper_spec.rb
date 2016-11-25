require "rails_helper"

RSpec.describe OrphanHelper, type: :helper do
  describe "#child_or_adult?" do
    context "when orphan is a child" do
      it "returns 'child'" do
        orphan = double "orphan", age_in_years: 17

        expect(child_or_adult? orphan).to eq "child"
      end
    end

    context "when orphan is an adult" do
      it "returns 'adult'" do
        orphan = double "orphan", age_in_years: 18

        expect(child_or_adult? orphan).to eq "adult"
      end
    end
  end
end
