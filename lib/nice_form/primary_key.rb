# frozen_string_literal: true

module NiceForm
  module PrimaryKey
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def primary_key(name, type = :integer)
        if name.is_a?(Array)
          type = name[1]
          name = name[0]
        end
        undefine_primary_key(form_primary_key)
        define_primary_key(name, type)
      end

      def form_primary_key
        @form_primary_key ||= define_primary_key(NiceForm.config.primary_key[0], NiceForm.config.primary_key[1])
      end

      def undefine_primary_key(name)
        if attribute_names.include?(name.to_s)
          undef_method(name.to_s) if respond_to?(name.to_s)
          undef_method("#{name}=") if respond_to?("#{name}=")
          attribute_types.delete(name.to_s)
          _default_attributes.send(:attributes).delete(name.to_s)
        end
      end

      def define_primary_key(name, type = :integer)
        attribute name, type
        @form_primary_key = name.to_s
      end
    end
  end
end
