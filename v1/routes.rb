module Xapi
  module Routes
    autoload :Home, 'v1/routes/home'
    autoload :Core, 'v1/routes/core'
    autoload :Tracks, 'v1/routes/tracks'
    autoload :Problems, 'v1/routes/problems'
    autoload :Assignments, 'v1/routes/assignments'
    autoload :Exercises, 'v1/routes/exercises'
    autoload :User, 'v1/routes/user'
    autoload :Docs, 'v1/routes/docs'
    autoload :Legacy, 'v1/routes/legacy'
  end
end
