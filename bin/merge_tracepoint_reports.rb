#!/usr/bin/env ruby
# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true

require 'pastel'
require 'tempfile'

RAILS_ROOT = File.expand_path(__FILE__)
ESCAPED_RAILS_ROOT = "#{RAILS_ROOT}/".gsub('/', '\/')
pastel = Pastel.new(enabled: true)

def merge_reports(main_report:, file_glob:)
  command = "jq -nc 'reduce inputs as $in (null; . + $in)'"
  command_args = "#{main_report} #{file_glob}"

  system("#{command} #{command_args} > #{main_report}")
  system("sed -i.bak 's/#{ESCAPED_RAILS_ROOT}//g' #{main_report}")
end

main_report = ARGV.shift
glob = ARGV.shift

if (files = Dir[glob]).any?
  puts pastel.on_blue.bold.white(
    "[HERMES] merging #{files.count} tracepoint reports",
  ).to_s

  merge_reports(main_report: main_report, file_glob: glob)

  puts pastel.on_green.bold.white(
    "[HERMES] finished merging #{files.count} tracepoint reports",
  ).to_s
else
  puts pastel.on_green.bold.black('[HERMES] no tracepoint reports merge').to_s
end
