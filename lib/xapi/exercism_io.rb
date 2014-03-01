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
      request '/api/v1/exercises', key
    end

    def self.code_for(key)
      request '/api/v1/iterations/latest', key
    end

    def self.conn
      conn = Faraday.new(:url => url) do |c|
        c.use Faraday::Adapter::NetHttp
      end
    end

    def self.request(path, key)
      response = conn.get do |req|
        req.url File.join(path)
        req.headers['User-Agent'] = "github.com/exercism/xapi"
        req.params['key'] = key
      end
      JSON.parse(response.body)
    end
  end
end
