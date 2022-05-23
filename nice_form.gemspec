# frozen_string_literal: true

require_relative "lib/nice_form/version"

Gem::Specification.new do |spec|
  spec.name = "nice_form"
  spec.version = NiceForm::VERSION
  spec.authors = ["Partytray"]
  spec.email = ["97254326+Partytray@users.noreply.github.com"]

  spec.summary = "A form object."
  spec.description = spec.summary
  spec.homepage = "https://github.com/partytray/nice_form"
  spec.required_ruby_version = ">= 2.4.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]
  spec.add_dependency "activemodel", ">= 5.1"
  spec.add_dependency "activesupport", ">= 5.1"
  spec.add_development_dependency "pry"
end
