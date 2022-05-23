# frozen_string_literal: true

require "rspec"

class SomeForm < NiceForm::Base
  attribute :name

  validates :name, presence: true
end

RSpec.describe NiceForm do
  context "validations" do
    it "#valid?" do
      form = SomeForm.new
      expect(form.valid?).to be_falsey
    end

    it "#errors" do
      form = SomeForm.new
      form.validate
      expect(form.errors[:name]).to be_present
    end

    it "#invalid?" do
      form = SomeForm.new
      expect(form.invalid?).to be_truthy
    end
  end

  after(:suite) do
    Object.send(:remove_const, :SomeForm)
  end
end
