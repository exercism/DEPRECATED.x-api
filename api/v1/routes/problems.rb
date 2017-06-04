module V1
  module Routes
    class Problems < Core
      get '/problems' do
        pg :summaries, locals: {
          specifications: Trackler.specifications,
          implementations: Trackler.implementations,
        }
      end

      # v1: brute force
      get '/problems/:slug' do |slug|
        specification = Trackler.specifications[slug]
        unless specification.exists?
          halt 404, { error: "No problem '%s'" % slug }.to_json
        end

        pg :summary, locals: {
          specification: specification,
          implementations: Trackler.implementations[slug],
        }
      end
    end
  end
end
