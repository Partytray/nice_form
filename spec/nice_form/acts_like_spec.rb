# frozen_string_literal: true

require "rspec"

class InferredForm < NiceForm::Base; end

class DefinedForm < NiceForm::Base
  self.acts_like = "tomato"
end

RSpec.describe NiceForm::ActsLike do
  context "inferred form" do
    it "gets inferred" do
      expect(InferredForm.model_name.name).to eq("Inferred")
    end
  end

  context "defined" do
    it "gets used" do
      expect(DefinedForm.model_name.name).to eq("Tomato")
    end
  end

  after(:suite) do
    Object.send(:remove_const, :InferredForm)
    Object.send(:remove_const, :DefinedForm)
  end
end
