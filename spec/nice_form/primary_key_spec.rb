# frozen_string_literal: true

require "rspec"

class DefaultKey < NiceForm::Base; end

class DefinedKey < NiceForm::Base
  self.acts_like = "tomato"
  primary_key :uuid
end

RSpec.describe NiceForm::PrimaryKey do
  context "default" do
    it "has id" do
      expect(DefaultKey.attribute_names).to include("id")
    end
  end

  context "defined" do
    it "does not have an ID" do
      expect(DefinedKey.attribute_names).to_not include("id")
    end
    it "has a uuid" do
      expect(DefinedKey.attribute_names).to include("uuid")
    end

    it "attribute_names on the object has a uuid" do
      expect(DefinedKey.new.attribute_names).to include("uuid")
    end

    it "attribute_names does not have an id" do
      expect(DefinedKey.new.attribute_names).to_not include("id")
    end
  end

  after(:suite) do
    Object.send(:remove_const, :DefaultKey)
    Object.send(:remove_const, :DefinedKey)
  end
end
