# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true
require 'pastel'
require 'json'
require 'pry'

module Hermes
  module Tracers
    module Tracepoint
      class << self
        attr_accessor :report
      end

      def self.report
        @report ||= {}
      end

      def self.reset
        @report = {}
      end

      def self.trace(root:, test_id:)
        HermesNative.set_rails_root(root)
        HermesNative.start
        yield
        HermesNative.stop

        report[test_id] = HermesNative.buffer.keys
      end
    end
  end
end
