require 'faraday'
require 'json'

module Xapi
  module ExercismIO
    def self.env
      ENV.fetch('RACK_ENV') { 'production' }
    end

    def self.url
      if env == 'production'
        'http://exercism.io'
      else
        'http://localhost:4567'
      end
    end

    def self.exercises_for(key)
      conn = Faraday.new(:url => url) do |c|
        c.use Faraday::Adapter::NetHttp
      end

      response = conn.get do |req|
        req.url File.join('/api/v1/exercises')
        req.headers['User-Agent'] = "github.com/exercism/xapi"
        req.params['key'] = key
      end
      JSON.parse(response.body)
    end
  end
end
