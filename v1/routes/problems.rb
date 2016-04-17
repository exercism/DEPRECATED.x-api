module V1
  module Routes
    class Problems < Core
      get '/problems' do
        pg :summaries, locals: {
          problems: ::Xapi.problems,
          implementations: ::Xapi.implementations,
        }
      end

      # v1: brute force
      get '/problems/:slug' do |slug|
        problem = ::Xapi.problems[slug]
        unless problem.exists?
          halt 404, { error: "No problem '%s'" % slug }.to_json
        end

        pg :summary, locals: {
          problem: problem,
          implementations: ::Xapi.implementations[slug],
        }
      end
    end
  end
end
