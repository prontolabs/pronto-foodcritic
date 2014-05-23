#!/usr/bin/env rake
require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Bundle the gem"
task :bundle do
  sh 'bundle check || bundle install'
  sh 'gem build *.gemspec'
  sh 'gem install *.gem'
  sh 'rm *.gem'
end

task(:default).clear
task default: [:bundle]
