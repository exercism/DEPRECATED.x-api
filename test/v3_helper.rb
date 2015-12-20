require_relative 'test_helper'
require 'rack/test'
require 'approvals'
require 'yaml'
require 'xapi'
require_relative '../v3'

Approvals.configure do |c|
  c.approvals_path = './test/fixtures/approvals/'
end

module Minitest
  module Assertions
    def assert_files_in_zip(files, zip_file)
      files_in_zip = file_names(zip_file)
      assert_equal files_in_zip.sort, files.sort
    end

    private

    def file_names(zip_file)
      names = []
      Zip::InputStream.open(zip_file) do |io|
        while (entry = io.get_next_entry)
          names << entry.name
        end
      end
      names
    end
  end
end
