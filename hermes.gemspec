# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hermes/version"

Gem::Specification.new do |s|
  s.name        = 'Hermes'
  s.version     = Hermes::VERSION
  s.summary     = "test impact analysis framework for H1"
  s.description = "Hermes is HackerOne's homegrown test impact analysis framework used for selective test running and dependency analysis."
  s.authors     = ["Alexander Jeurissen"]
  s.email       = 'alexander@hackerone.com'
  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage    = 'https://github.com/Hacker0x01/hermes'
  s.license     = 'MIT'
end
