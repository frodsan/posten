require_relative "lib/posten/version"

Gem::Specification.new do |s|
  s.name        = "posten"
  s.version     = Posten::VERSION
  s.summary     = "Mail delivery"
  s.description = s.summary
  s.authors     = ["Francesco Rodríguez"]
  s.email       = ["frodsan@protonmail.ch"]
  s.homepage    = "https://github.com/harmoni/posten"
  s.license     = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "malone", "~> 1.2.0"
  s.add_dependency "mote", "~> 1.1.4"
  s.add_dependency "seteable", "1.1.0"

  s.add_development_dependency "cutest", "~> 1.2"
end
