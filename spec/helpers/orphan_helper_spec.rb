require "rails_helper"

RSpec.describe OrphanHelper, type: :helper do
  describe "#orphan_highlight_class" do
    context "when active child" do
      example do
        orphan = double "orphan", adult?: false, active?: true

        expect(orphan_highlight_class(orphan)).to be_nil
      end
    end

    context "when inactive child" do
      example do
        orphan = double "orphan", adult?: false, active?: false

        expect(orphan_highlight_class(orphan)).to be_nil
      end
    end

    context "when inactive adult" do
      example do
        orphan = double "orphan", adult?: true, active?: false

        expect(orphan_highlight_class(orphan)).to be_nil
      end
    end

    context "when active adult" do
      example do
        orphan = double "orphan", adult?: true, active?: true

        expect(orphan_highlight_class(orphan)).to eq "active_adult"
      end
    end
  end
end
