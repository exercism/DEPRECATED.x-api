module V1
  module Routes
    class Exercises < Core
      helpers do
        def homework
          Xapi::Homework.new(params[:key], config.track_ids, path)
        end
      end

      get '/v2/exercises' do
        require_key
        problems = forward_errors do
          filter(homework.problems, (params[:tracks] || []))
        end
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/restore' do
        require_key
        problems = forward_errors do
          Xapi::Backup.restore(params[:key])
        end
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/:language' do |language|
        language = language.downcase
        require_key
        problems = forward_errors { homework.problems_in(language) }
        pg :problems, locals: { problems: problems }
      end

      get '/v2/exercises/:language/:slug' do |language, slug|
        language, slug = language.downcase, slug.downcase

        # no need to authenticate for this one
        problem = config.find(language).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        begin
          Xapi::ExercismIO.fetch(params[:key], problem.track_id, problem.slug)
        rescue
          # don't fail just because we can't track it.
        end
        pg :problems, locals: { problems: [problem] }
      end

      private

      def filter(what, track_ids=[])
        return what if track_ids.empty?
        what.select { |it| track_ids.include?(it.track_id) }
      end
    end
  end
end
