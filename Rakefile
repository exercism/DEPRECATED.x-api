require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
end

task default: :test
