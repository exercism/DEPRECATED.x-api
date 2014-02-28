module Xapi
  module Routes
    class Demo < Core
      get '/demo' do
        pg :exercises, locals: {exercises: Xapi::Demo.exercises}
      end
    end
  end
end
