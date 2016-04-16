module V1
  module Routes
    class Problems < Core
      get '/problems' do
        pg :summaries, locals: {
          problems: ::Rewrite.problems,
          implementations: ::Rewrite.implementations,
        }
      end

      # v1: brute force
      get '/problems/:slug' do |slug|
        problem = ::Rewrite.problems[slug]
        unless problem.exists?
          halt 404, { error: "No problem '%s'" % slug }.to_json
        end

        pg :summary, locals: {
          problem: problem,
          implementations: ::Rewrite.implementations[slug],
        }
      end
    end
  end
end
