module V3
  module Routes
    class Problems < Core
      get '/problems/data-todos' do
        problems = Trackler.problems.select { |problem|
          problem.canonical_data_url.nil?
        }

        pg :"problems/data_todos", locals: {
          problems: problems,
          implementations: Trackler.implementations,
        }
      end

      get '/problems/:slug/todo' do |slug|
        implementations = Trackler.implementations[slug]
        todos = Trackler.tracks.reject { |track|
          track.slugs.include?(slug)
        }.map(&:id)

        pg :"problem/todos", locals: {
          problem: Trackler.problems[slug],
          todos: todos,
          implementations: implementations,
        }
      end
    end
  end
end
