
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mellat/version"

Gem::Specification.new do |spec|
  spec.name          = "bank_gateway_mellat"
  spec.version       = Mellat::VERSION
  spec.authors       = ["Mohammad", "Amirhossein"]
  spec.email         = ["mohammad.shamami21@gmail.com"]
  spec.summary       = 'Help you to communicate better with Mellat payment gateway'
  spec.description   = 'Help you to handle all requests to Mellat payment gateway'
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '~> 2.4'
  # spec.add_development_dependency 'bundler', '~> 2.0'
  # spec.add_development_dependency 'rake', '~> 10.0'
  # spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'rest-client', '~> 2.0.2', '>= 2.0.2'
  spec.add_runtime_dependency 'savon', '~> 2.12.0', '>= 2.12.0'
end
