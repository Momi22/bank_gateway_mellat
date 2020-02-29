# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/mellat/version'

Gem::Specification.new do |spec|
  spec.name          = 'bank_gateway_mellat'
  spec.version       = Mellat::VERSION
  spec.authors       = ['Mohammad']
  spec.email         = ['mohammad.shamami21@gmail.com']
  spec.summary       = 'Help you to communicate better with Mellat payment gateway'
  spec.description   = 'Help you to handle all requests to Mellat payment gateway'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.rb']
  spec.homepage      = 'https://gitlab.takhfifan.com/m.shamami/bank-gateway-mellat'
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  # spec.required_ruby_version = '~> 2.5'

  spec.add_runtime_dependency 'savon' , '~> 2.12.0', '>= 2.12.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
