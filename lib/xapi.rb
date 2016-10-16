libraries = Dir[File.expand_path('../xapi/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end

# Xapi assembles Exercism language track data.
module Xapi
  if ENV["RACK_ENV"] == "test"
    ROOT = "./test/fixtures"
    ROOT_URL = "http://x.exercism.io"
  elsif ENV["RACK_ENV"] == "development"
    ROOT = "."
    ROOT_URL = "http://localhost:9292"
  else
    ROOT = "."
    ROOT_URL = "http://x.exercism.io"
  end
  DEFAULT_PATH = "."
  REPO_URL = "https://github.com/exercism/x-api"
  EXERCISM_URL = "https://github.com/exercism/exercism.io"
  CONTRIBUTING_URL = "%s/blob/master/CONTRIBUTING.md" % REPO_URL
end
