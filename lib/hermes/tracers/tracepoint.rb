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
        attr_accessor :report, :tracer, :buffer
      end

      def self.report
        @report ||= {}
      end

      def self.buffer
        @buffer ||= {}
      end

      def self.tracer
        @tracer ||= begin
          tracepoint_scope = Hermes.configuration.tracepoint_scope
          rspec_rails_root = "#{Rails.root}/"

          TracePoint.new(*tracepoint_scope) do |tp|
            path = tp.path

            # NOTE: only log paths in our rails app
            # ignore gem paths like:
            # ~/.rbenv/versions/2.6.7/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.4/...
            next false unless path.starts_with?(rspec_rails_root)

            # NOTE: we mimic the behavior of a Set but use a lightweight hash instead
            buffer[path] = true
          end
        end
      end

      def self.reset
        @report = {}
        @buffer = {}
        @tracer = nil
      end

      def self.enable(test_id:)
        @buffer = {}

        tracer.enable { yield }

        report[test_id] = buffer.keys
      end
    end
  end
end
