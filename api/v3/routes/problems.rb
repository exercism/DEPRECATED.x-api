module V3
  module Routes
    class Problems < Core
      get '/problems/data-todos' do
        specifications = Trackler.specifications.select { |specification|
          specification.canonical_data_url.nil?
        }

        pg :"problems/data_todos", locals: {
          specifications: specifications,
          implementations: Trackler.implementations,
        }
      end

      get '/problems/:slug/todo' do |slug|
        implementations = Trackler.implementations[slug]
        todos = Trackler.tracks.reject { |track|
          track.slugs.include?(slug)
        }.map(&:id)

        pg :"problem/todos", locals: {
          problem: Trackler.specifications[slug],
          todos: todos,
          implementations: implementations,
        }
      end
    end
  end
end
