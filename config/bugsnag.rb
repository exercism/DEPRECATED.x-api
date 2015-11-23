Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.project_root = File.expand_path("../..", __FILE__)
  config.notify_release_stages = %w(production development)
end
