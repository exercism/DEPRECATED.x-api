module V1
  module Routes
    class Problems < Core
      get '/problems' do
        pg :summaries, locals: {
          problems: Trackler.problems,
          implementations: Trackler.implementations,
        }
      end

      # v1: brute force
      get '/problems/:slug' do |slug|
        problem = Trackler.problems[slug]
        unless problem.exists?
          halt 404, { error: "No problem '%s'" % slug }.to_json
        end

        pg :summary, locals: {
          problem: problem,
          implementations: Trackler.implementations[slug],
        }
      end
    end
  end
end
