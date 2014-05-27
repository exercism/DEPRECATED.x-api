module Xapi
  module Routes
    class Demo < Core
      get '/demo' do
        pg :problems, locals: {problems: Xapi::Demo.problems}
      end
    end
  end
end
