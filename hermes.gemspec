$:.push File.expand_path("../lib", __FILE__)
require "hermes/version"

Gem::Specification.new do |s|
  s.name        = 'Hermes'
  s.date     = '2021-08-11'
  s.version     = Hermes::VERSION
  s.summary     = 'Test impact analysis framework used at H1'
  s.description = 'Hermes is HackerOne\'s homegrown test impact analysis framework used for selective test running and dependency analysis.'
  s.authors     = ['HackerOne Open Source', 'Alexander Jeurissen']
  s.email    = ["opensource+fluent_logger_rails@hackerone.com", "alexander@hackerone.com"]
  s.homepage    = 'https://github.com/Hacker0x01/hermes'
  s.license     = 'MIT'

  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  s.add_development_dependency 'pry', '~> 0.14.1'

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = "#{s.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
