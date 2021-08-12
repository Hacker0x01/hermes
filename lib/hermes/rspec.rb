# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true

require 'pastel'
require 'json'
require 'pry'
require 'hermes/tracers/tracepoint'

RSpec.configure do |config|
  next unless Hermes.configuration.rspec_enabled?

  pastel = Hermes.pastel
  puts pastel.bold.blue('[HERMES] rspec tracing enabled').to_s

  RSPEC_TRACEPOINT_REPORT = "#{Rails.root}/knapsack_rspec_tracepoint_report.json"

  config.around do |example|
    Hermes::Tracers::Tracepoint.enable { example.run }
  end

  # NOTE: this occurs after a knapsack node finishes executing
  # write the $rspec_tracepoint_report to disk
  at_exit do
    file = File.open(RSPEC_TRACEPOINT_REPORT, 'w')
    file.puts Hermes::Tracers::Tracepoint.report.to_json
    file.close

    puts pastel.bold.green('[HERMES] tracepoint report generated').to_s
    Hermes::Tracers::Tracepoint.reset
  end
end
