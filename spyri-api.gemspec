# frozen_string_literal: true

require_relative "lib/spyri/api/version"

Gem::Specification.new do |spec|
  spec.name          = "spyri-api"
  spec.version       = SpyriApi::VERSION
  spec.authors       = ["pabois"]
  spec.email         = ["pierreandre.boissinot@noesya.coop"]

  spec.summary       = "Ruby client library for the Spyri API"
  spec.homepage      = "Thttps://github.com/letemps-ch/spyri-api"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/letemps-ch/spyri-api"
  spec.metadata["changelog_uri"] = "https://github.com/letemps-ch/spyri-api/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "excon", "~> 1.0"

end
