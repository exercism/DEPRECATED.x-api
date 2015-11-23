module V1
  module Routes
    class Problems < Core
      get '/problems' do
        directory = Xapi::Metadata.load(path).directory
        config.track_ids.each do |language|
          config.find(language).problems.each do |problem|
            directory[problem.slug].append(problem.track_id)
          end
        end
        pg :summaries, locals: { summaries: directory.values.sort_by(&:slug) }
      end

      # v1: brute force
      get '/problems/:slug' do |slug|
        directory = Xapi::Metadata.load(path).directory
        unless directory[slug]
          halt 404, { error: "Unknown problem '#{slug}'" }.to_json
        end
        config.track_ids.each do |language|
          config.find(language).problems.each do |problem|
            directory[problem.slug].append(problem.track_id)
          end
        end
        pg :summary, locals: { summary: directory[slug] }
      end
    end
  end
end
