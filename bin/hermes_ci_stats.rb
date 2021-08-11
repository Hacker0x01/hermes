#!/usr/bin/env ruby
# Copyright 2021 HackerOne Inc.
#
# frozen_string_literal: true

require "json"
require 'pastel'
require "set"

class HermesCIAnalyzer
  CI_PIPELINE_ID = ENV.fetch('CI_PIPELINE_ID', -1)
  CI_JOB_ID = ENV.fetch('CI_JOB_ID', -1)
  CI_MERGE_REQUEST = ENV.fetch('CI_MERGE_REQUEST_REF_PATH', -1)

  def write_details
    unless @source_file.lines.count.positive?
      puts @pastel.on_yellow.bold.black("[HERMES_CI] no test_cases to write").to_s
      return
    end

    log_entries = @source_file.lines.map do |test_case|
      {
        log_category: 'test_impact_analysis_stats_detail',
        sub_category: @sub_category,
        merge_request: CI_MERGE_REQUEST,
        job_id: CI_JOB_ID,
        pipeline_id: CI_PIPELINE_ID,
        test_case: test_case.chomp,
      }.to_json
    end

    puts @pastel.bold.blue("[HERMES_CI] writing #{@source_file.lines.count} test_cases").to_s
    @output.puts log_entries
  end

  def write_summary
    summary = {
      log_category: 'test_impact_analysis_stats_summary',
      sub_category: @sub_category,
      call_graph_hits: @source_file.lines.count,
      reason: @reason,
      merge_request: CI_MERGE_REQUEST,
      job_id: CI_JOB_ID,
      pipeline_id: CI_PIPELINE_ID,
    }

    puts @pastel.bold.blue("[HERMES_CI] writing summary").to_s
    @output.puts summary.to_json
  end

  def initialize(reports)
    @pastel = Pastel.new(enabled: true)
    @output = File.new('job_data.json', 'w')

    reports.each do |source_file|
      @sub_category = 'unknown'
      @sub_category = 'acceptance' if source_file.include? 'acceptance'
      @sub_category = 'integration' if source_file.include? 'integration'

      puts @pastel.on_blue.bold.white("[HERMES_CI] processing #{source_file}").to_s
      @source_file = File.read(source_file)
      @reason = File.read("#{source_file}.log").chomp

      write_summary
      write_details

      puts @pastel.on_green.bold.black("[HERMES_CI] finished procesing #{source_file}").to_s
    end
  ensure
    @output.close
  end
end

HermesCIAnalyzer.new ARGV
