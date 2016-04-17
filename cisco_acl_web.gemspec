# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cisco_acl_web/version'

Gem::Specification.new do |spec|
  spec.name          = 'cisco_acl_web'
  spec.version       = CiscoAclWeb::VERSION
  spec.authors       = ['stereocat']
  spec.email         = ['stereocat@gmail.com']
  spec.summary       = %q{Cisco IOS Analyzer WebUI}
  spec.description   = %q{Web Frontend of Cisco IOS Interpreter}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'sinatra', '~> 1.4.7'
  spec.add_runtime_dependency 'haml', '~> 4.0.7'
  spec.add_runtime_dependency 'cisco_acl_intp', '~> 0.0.4'
  spec.add_development_dependency 'bundler', '~> 1.11.2'
  spec.add_development_dependency 'rake'
end
