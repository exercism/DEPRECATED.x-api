require 'zip'
module Xapi
  # Module to return all the files in given path and zip them
  module FileBundle
    def self.create_zip(base_dir, paths)
      Zip::OutputStream.write_buffer do |io|
        paths.each do |path|
          io.put_next_entry(path.relative_path_from(base_dir))
          io.print IO.read(path)
        end
        yield io if block_given?
      end
    end

    def self.paths(base_dir, ignore_patterns=[])
      Pathname.glob("#{base_dir}/**/*", File::FNM_DOTMATCH).reject {|file|
        file.directory? ||
          ignore_patterns.any? { |pattern| file.to_s =~ pattern }
      }.sort
    end
  end
end
