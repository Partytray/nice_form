# frozen_string_literal: true

module NiceForm
  class Configuration
    attr_accessor :primary_key

    def initialize
      @primary_key = %i[id integer]
    end

    def primary_key=(val)
      @primary_key = if val.is_a?(Array)
                       val
                     else
                       [val, :integer]
                     end
    end
  end

  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end
end
