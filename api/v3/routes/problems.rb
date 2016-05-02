module V3
  module Routes
    class Problems < Core
      get '/problems/data-todos' do
        problems = ::Xapi.problems.select { |problem|
          problem.json_url.nil?
        }

        pg :"problems/data_todos", locals: {
          problems: problems,
          implementations: ::Xapi.implementations,
        }
      end

      get '/problems/:slug/todo' do |slug|
        implementations = ::Xapi.implementations[slug]
        todos = ::Xapi.tracks.reject { |track|
          track.slugs.include?(slug)
        }.map(&:id)

        pg :"problem/todos", locals: {
          problem: ::Xapi.problems[slug],
          todos: todos,
          implementations: implementations,
        }
      end
    end
  end
end
