require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
end

desc "Run each test file independently"
namespace :test do
  task :each do
    files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
    failures = files.reject do |file|
      command = "ruby #{file}"
      puts command
      system(command)
    end

    unless failures.empty?
      puts "FAILURES IN:"
      failures.each do |failure|
        puts failure
      end
      exit 1
    end
  end
end

task default: :test
