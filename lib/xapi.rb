libraries = Dir[File.expand_path('../xapi/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end
