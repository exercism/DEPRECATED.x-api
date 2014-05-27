module Xapi
  module Routes
    class Problems < Core
      get '/problems/:language' do |language|
        track = Xapi::Config.track_in(language)
        problems = track.problem_ids.map {|id|
          Problem.new(track.slug, id, 'fresh', '.')
        }
        pg :exercises, locals: {exercises: problems}
      end
    end
  end
end
