module Xapi
  # Tests represents the test included with the problem
  class Tests
    attr_reader :files, :path

    def initialize(attributes)
      @path = attributes[:path]
      @files = attributes[:files]
    end

    def test_files
      files.select { |filename, _code| filename =~ test_pattern }
    end

    private

    def config_data
      @config_data ||= JSON.parse(read_config)
    end

    def read_config
      File.read(File.join(path, 'config.json'))
    end

    def test_pattern
      if config_data.key?('test_pattern')
        Regexp.new(config_data['test_pattern'])
      else
        # boolean argument means case insensitive
        Regexp.new('test', true)
      end
    end
  end
end
