# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true

require 'pastel'
require 'json'
require 'pry'
require 'hermes/tracers/tracepoint'

if Hermes.configuration.cucumber_tracing_enabled?
  pastel = Hermes.pastel
  puts pastel.bold.blue('[HERMES] cucumber tracing enabled').to_s

  CUCUMBER_TRACEPOINT_REPORT = \
    "#{Rails.root}/knapsack_cucumber_tracepoint_report.json"

  Around do |scenario, block|
    Hermes::Tracers::Tracepoint.trace(test_id: scenario.test_id) { block.call }
  end

  # NOTE: this occurs after a knapsack node finishes executing
  # write the $rspec_tracepoint_report to disk
  at_exit do
    file = File.open(CUCUMBER_TRACEPOINT_REPORT, 'w')
    file.puts Hermes::Tracers::Tracepoint.report.to_json
    file.close

    puts pastel.bold.green('[HERMES] tracepoint report generated').to_s
    Hermes::Tracers::Tracepoint.reset
  end
end

