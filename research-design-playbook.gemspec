# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "research-design-playbook"
  spec.version       = "0.1"
  spec.authors       = ["Solution8 Design Team"]
  spec.email         = ["dawid@ai-r.dk"]

  spec.summary       = %q{A record of how we work together and the resources we use.}
  spec.homepage      = "https://github.com/le-dawg/S8-Onboarding-Playbook"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|bin|_layouts|_includes|lib|Rakefile|_sass|LICENSE|README)}i) }
  spec.executables   << 'just-the-docs'

  spec.add_runtime_dependency "jekyll", "~> 3.8.5"
  spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.0"
  spec.add_runtime_dependency "rake", "~> 12.3.1"

  spec.add_development_dependency "bundler", "~> 2.2.16"
end
