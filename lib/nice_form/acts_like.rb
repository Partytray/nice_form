# frozen_string_literal: true

module NiceForm
  # Allows you to define the model name of the form
  #
  #   class CatForm < NiceForm::Base
  #     self.acts_like = :cat
  #   end
  #
  # Automatically infers the name if not set.
  module ActsLike
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def acts_like=(val)
        @acts_like_model = val.to_s.underscore.to_sym
      end

      def acts_like_model_name
        @acts_like_model || inferred_model_name
      end

      def inferred_model_name
        class_name = name.demodulize
        return :form if class_name == "Form"

        class_name.delete_suffix("Form").underscore.to_sym
      end

      def model_name
        ActiveModel::Name.new(self, nil, acts_like_model_name.to_s.camelize)
      end
    end
  end
end
