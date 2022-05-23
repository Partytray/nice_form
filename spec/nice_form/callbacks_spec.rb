# frozen_string_literal: true

require "rspec"

class SomeValidationForm < NiceForm::Base
  attribute :name
  before_validation :set_name

  private

  def set_name
    self.name = "bob"
  end
end

RSpec.describe NiceForm::Base do
  context "validation" do
    it "gets invoked correctly" do
      form = SomeValidationForm.new
      expect(form.valid?).to be_truthy
    end
  end

  after(:suite) do
    Object.send(:remove_const, :SomeValidationForm)
  end
end
