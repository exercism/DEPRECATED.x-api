module Xapi
  module Routes
    class Demo < Core
      # deprecated. See: /problems/demo
      get '/demo' do
        pg :assignments, locals: { assignments: Xapi::Demo.problems }
      end
    end
  end
end
