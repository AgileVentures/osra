require "rails_helper"

RSpec.describe OrphanHelper, type: :helper do
  describe "#active_adult?" do
    context "when active child" do
      example do
        orphan = double "orphan", adult?: false, active?: true

        expect(active_adult?(orphan)).to eq ""
      end
    end

    context "when inactive child" do
      example do
        orphan = double "orphan", adult?: false, active?: false

        expect(active_adult?(orphan)).to eq ""
      end
    end

    context "when inactive adult" do
      example do
        orphan = double "orphan", adult?: true, active?: false

        expect(active_adult?(orphan)).to eq ""
      end
    end

    context "when active adult" do
      example do
        orphan = double "orphan", adult?: true, active?: true

        expect(active_adult?(orphan)).to eq "active_adult"
      end
    end
  end
end
