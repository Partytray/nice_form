# frozen_string_literal: true

require 'active_model'

require_relative "instantiation"
require_relative "acts_like"
require_relative "primary_key"

module NiceForm
  class Base
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment
    include ActiveModel::Callbacks
    include ActiveModel::Conversion
    include ActiveModel::Validations

    include ActsLike
    include Instantiation
    include PrimaryKey

    define_model_callbacks :validation, only: :before

    attr_reader :context

    def self.inherited(klass)
      super
      klass.primary_key(*NiceForm.config.primary_key)
    end

    def initialize(attributes = {})
      assign_attributes(attributes) if attributes
      super()
    end

    def self.inspect
      attr_list = attribute_types.map { |name, type| "#{name}: #{type.type}" } * ", "
      "#{self.name}(#{attr_list})"
    end

    def inspect
      inspection = if defined?(@attributes) && @attributes
                     self.class.attribute_names.filter_map do |name|
                       "#{name}: #{attribute_for_inspect(name)}" if _has_attribute?(name)
                     end.join(", ")
                   else
                     "not initialized"
                   end

      "#<#{self.class} #{inspection}>"
    end

    def attributes
      attrs = [self.class.form_primary_key]

      attrs << if ::NiceForm.config.primary_key.is_a?(Array)
                 ::NiceForm.config.primary_key[0].to_s
               else
                 ::NiceForm::Config.primary_key.to_s
               end

      super.except(*attrs)
    end

    def to_model
      self
    end

    def to_param
      attribute(self.class.form_primary_key)
    end

    def to_key
      key = attribute(self.class.form_primary_key)
      return nil if key.nil?

      [key]
    end

    def persisted?
      to_param.present?
    end

    def with_context(attrs = {})
      @context = attrs
    end

    private

    def format_for_inspect(value)
      if value.nil?
        value.inspect
      elsif value.is_a?(String) && value.length > 50
        "#{value[0, 50]}...".inspect
      elsif value.is_a?(Date) || value.is_a?(Time)
        %("#{value.to_fs(:inspect)}")
      else
        value.inspect
      end
    end

    def attribute_for_inspect(attr_name)
      attr_name = attr_name.to_s
      attr_name = self.class.attribute_aliases[attr_name] || attr_name
      value = _read_attribute(attr_name)
      format_for_inspect(value)
    end

    def _has_attribute?(attr_name)
      @attributes.key?(attr_name)
    end
  end
end
