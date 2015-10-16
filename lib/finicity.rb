require 'httpclient'
require 'httpclient/include_client'
require 'logger'
require 'saxomattic'
require 'uri'

require 'finicity/version'

require 'finicity/client'
require 'finicity/configuration'
require 'finicity/errors'
require 'finicity/logger'

require 'finicity/v1'
require 'finicity/v2'

module Finicity
  ##
  # Class methods
  #
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @config ||= ::Finicity::Configuration.new
  end

  def self.logger
    configuration.logger
  end

  # Class aliases
  class << self
    alias_method :config, :configuration
  end

  # Initialize the config object
  config
end

require "finicity/railtie" if defined?(Rails)
