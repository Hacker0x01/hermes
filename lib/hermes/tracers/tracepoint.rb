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

      def self.trace(test_id:)
        Hermes::Native.start
        yield
        Hermes::Native.stop

        report[test_id] = Hermes::Native.buffer.keys
      end
    end
  end
end
