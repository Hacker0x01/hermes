# Copyright 2021 HackerOne Inc.
#
module Hermes
  class Configuration
    attr_accessor :tracepoint_scope

    def initialize
      @tracepoint_scope = nil
      @rspec_enabled = ENV['CI_MERGE_REQUEST_ID'] == '0'
    end

    def rspec_enabled?
      @rspec_enabled == true
    end
  end
end
