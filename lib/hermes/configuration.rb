# Copyright 2021 HackerOne Inc.
#
module Hermes
  class Configuration
    attr_accessor :rspec_enabled
    attr_accessor :cucumber_enabled

    def initialize
      ci = !ENV['CI'].nil?
      @rspec_enabled = ci && !ENV['CI_MERGE_REQUEST_REF_PATH'].nil?
      @cucumber_enabled = ci && !ENV['CI_MERGE_REQUEST_REF_PATH'].nil?
    end

    def rspec_tracing_enabled?
      @rspec_enabled == true
    end

    def cucumber_tracing_enabled?
      @rspec_enabled == true
    end
  end
end
