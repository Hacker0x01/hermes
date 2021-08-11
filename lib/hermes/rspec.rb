# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

require 'pastel'
require 'json'
require 'pry'

RSpec.configure do |config|
  next unless Hermes.configuration.rspec_enabled?

  # NOTE: we use a global var as its the only way
  # to ensure the var persists across scenarios.
  # This allows us to limit the number of file writes
  # which drastically improves performance
  $rspec_tracepoint_report = {}
  $rspec_rails_root = "#{Rails.root}/"

  RSPEC_TRACEPOINT_REPORT = "#{$rspec_rails_root}/knapsack_rspec_tracepoint_report.json"

  pastel = Pastel.new(enabled: true)

  puts pastel.bold.blue('[HERMES] rspec tracing enabled').to_s

  tracepoint_scope = Hermes.configuration.tracepoint_scope
  config.around do |example|
    traces = {}

    tracer = TracePoint.new(*tracepoint_scope) do |tp|
      path = tp.path

      # NOTE: only log paths in our rails app
      # ignore gem paths like:
      # ~/.rbenv/versions/2.6.7/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.4/lib/active_record/model_schema.rb
      next false unless path.starts_with?($rspec_rails_root)

      # NOTE: we mimic the behavior of a Set but use a lightweight hash instead
      traces[path] = true
    end

    tracer.enable { example.run }

    $rspec_tracepoint_report[example.example.id] = traces.keys
  end

  # NOTE: this occurs after a knapsack node finishes executing
  # write the $rspec_tracepoint_report to disk
  at_exit do
    file = File.open(RSPEC_TRACEPOINT_REPORT, 'w')
    file.puts $rspec_tracepoint_report.to_json
    file.close

    puts pastel.bold.blue('[HERMES] tracepoint report generated').to_s
  end
end

# rubocop:enable Style/GlobalVars
