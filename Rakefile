require 'rake/testtask'

Rake::TestTask.new do |t|
  require 'bundler'
  Bundler.require
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/fixtures/**/*')
end

namespace :problems do
  desc "verify that configured problems actually exist"
  task :verify do
    require 'json'
    require './lib/xapi/problem'
    require './lib/xapi/progression'

    Dir.glob("./problems/*").each do |path|
      language = File.basename(path)
      progression = Xapi::Progression.new(language, [], '.')
      slugs = progression.slugs.reject { |slug|
        File.exists?("./problems/#{language}/#{slug}")
      }
      unless slugs.empty?
        STDERR.puts "\nMissing Problems:"
        slugs.each do |slug|
          STDERR.puts "\t#{slug}"
        end
        STDERR.puts "\nPerhaps you forgot to run\n`git submodule init && git submodule update`\n"
        exit 1
      end
    end

  end
end

task default: :test
