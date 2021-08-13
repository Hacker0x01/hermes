# Copyright 2021 HackerOne Inc.
#
require 'hermes/configuration'
require 'hermes/version'

module Hermes
  class << self
    attr_accessor :configuration, :pastel
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.pastel
    @pastel ||= Pastel.new(enabled: true)
  end

  def self.configure
    yield(configuration)
  end

  def self.version
    Hermes::VERSION
  end
end
