# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'pronto/foodcritic/version'

Gem::Specification.new do |s|
  s.name        = 'pronto-foodcritic'
  s.version     = Pronto::FoodCriticVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Mindaugas Mozūras'
  s.email       = 'mindaugas.mozuras@gmail.com'
  s.homepage    = 'http://github.org/mmozuras/pronto-foodcritic'
  s.summary     = 'Pronto runner for Food Critic, lint tool for chef'

  s.required_rubygems_version = '>= 1.3.6'
  s.license = 'MIT'

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'foodcritic', '~> 3.0.0'
  s.add_dependency 'pronto', '~> 0.2.0'
  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14.0'
end
