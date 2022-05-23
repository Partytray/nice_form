# frozen_string_literal: true

require "rspec"

class FakeForm < NiceForm::Base
  attribute :name
  attribute :address
  attribute :dob
end

class OtherClass
  include ActiveModel::Model
  attr_accessor :id, :name, :not_present
end

RSpec.describe NiceForm::Instantiation do
  context "from_params" do
    context "valid params" do
      it "sets the params" do
        params = { name: "bob", address: "1 place", dob: "yesterday" }
        instance = FakeForm.from_params(params)
        expect(instance.name).to eq("bob")
      end
    end
  end

  context "from_model" do
    context "valid params" do
      subject! do
        other_model = OtherClass.new(id: 1, name: "bob", not_present: "here")
        FakeForm.from_model(other_model)
      end

      it "sets name" do
        expect(subject.name).to eq("bob")
      end

      it "sets id" do
        expect(subject.id).to eq(1)
      end
    end
  end

  after(:suite) do
    Object.send(:remove_const, :FakeForm)
    Object.send(:remove_const, :OtherClass)
  end
end
