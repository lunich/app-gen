# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'ruby-app-gen'
  s.version= '0.1.1'
  s.summary = 'AppGen ruby gem'
  s.description = 'A simple gem to generate a ruby app'
  s.executables = ['app-gen']
  s.authors = ['Dima Lunich']
  s.email = 'dima.lunich@gmail.com'
  s.files = Dir['lib/**/*']
  s.license = 'MIT'
  s.homepage = 'https://github.com/lunich/ruby-app-gen'

  s.add_runtime_dependency 'activesupport', '~> 6.1'
  s.add_runtime_dependency 'erubi', '~> 1.10'
  s.add_runtime_dependency 'thor', '~> 1.1'
  s.add_runtime_dependency 'zeitwerk', '~> 2.5'
end
