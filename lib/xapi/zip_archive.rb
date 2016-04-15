require 'zip'

# ZipArchize provides a compressed problem implementation.
# It will be delivered via 'exercism fetch'.
class ZipArchive
  def self.write(scr, dst)
    new(scr, dst).create
  end

  attr_accessor :scr, :dst
  def initialize(scr, dst)
    @scr = scr
    @dst = dst
  end

  def create
    entries = remove_unwanted_entries(scr)

    ::Zip::File.open(dst, ::Zip::File::CREATE) do |io|
      write_entries entries, '', io
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, dir, io)
    entries.each do |e|
      file = dir == '' ? e : File.join(dir, e)
      disk_file = File.join(scr, file)

      if File.directory? disk_file
        recursively_deflate_directory(disk_file, io, file)
      else
        add(disk_file, io, file)
      end
    end
  end

  def recursively_deflate_directory(disk_file, io, file)
    io.mkdir file
    subdir = remove_unwanted_entries(disk_file)
    write_entries subdir, file, io
  end

  def add(disk_file, io, file)
    io.get_output_stream(file) do |f|
      f.puts(File.open(disk_file, 'rb').read)
    end
  end

  def remove_unwanted_entries(file)
    (Dir.entries(file) - %w(. ..)).reject {|f|
      f =~ /example/i || f =~ /HINTS\.md/
    }
  end
end
