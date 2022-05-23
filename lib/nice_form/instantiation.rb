# frozen_string_literal: true

module NiceForm
  module Instantiation
    def self.included(klass)
      klass.include FromParams
      klass.include FromHash
      klass.include FromModel
      klass.include FromJson
    end

    module FromHash
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def from_hash(hash)
          from_params(hash)
        end
      end
    end

    module FromParams
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def from_params(params, additional_params = {})
          instance = new
          instance.assign_attributes(params.merge(additional_params))
          instance
        end
      end
    end

    module FromModel
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def from_model(model)
          instance = new
          instance.class.attribute_names.each do |attr|
            instance.public_send("#{attr}=", model.public_send(attr)) if model.respond_to?(attr)
          end
          instance.map_model(model)
          instance
        end
      end

      # assign attributes to self
      def map_model(model); end
    end

    module FromJson
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def from_json(string)
          from_params(JSON.parse(string))
        end
      end
    end
  end
end
