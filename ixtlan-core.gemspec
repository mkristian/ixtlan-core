# -*- mode: ruby -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-core'
  s.version = '0.2.0'

  s.summary = 'cache header control, dynamic configuration, and rails generator templates'
  s.description = 'base for some gems related to protect privacy and increase security along some other utils'
  s.homepage = 'http://github.com/mkristian/ixtlan-core'

  s.authors = ['mkristian']
  s.email = ['m.kristian@web.de']

  s.files = Dir['MIT-LICENSE']
  s.licenses << 'MIT-LICENSE'
#  s.files += Dir['History.txt']
  s.files += Dir['README.textile']
#  s.extra_rdoc_files = ['History.txt','README.textile']
  s.rdoc_options = ['--main','README.textile']
  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.files += Dir['features/**/*rb']
  s.files += Dir['features/**/*feature']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.test_files += Dir['features/*.feature']
  s.test_files += Dir['features/step_definitions/*.rb']
  s.add_dependency 'slf4r', '~> 0.4.2'
  s.add_development_dependency 'rails', '3.0.5'
  s.add_development_dependency 'rspec', '2.4.0'
  s.add_development_dependency 'cucumber', '0.9.4'
  s.add_development_dependency 'ruby-maven', '0.8.3.0.2.0.26.0'
end

# vim: syntax=Ruby
