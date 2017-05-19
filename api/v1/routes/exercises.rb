module V1
  module Routes
    # Gawd. This is a whole nother level of hack.
    class Exercises < Core
      get '/v2/exercises/restore' do
        require_key
        solutions = forward_errors do
          Xapi::ExercismIO.code_for(params[:key])
        end

        implementations = []
        solutions.each do |solution|
          track = Trackler.tracks[solution["track"]]
          next unless track.exists?

          ti = track.implementations[solution["slug"]]
          next unless ti.exists?

          implementation = ti.dup
          implementation.merge_files(solution["files"])
          implementations << implementation
        end

        pg :implementations, locals: { implementations: implementations }
      end

      get '/v2/exercises' do
        require_key

        track_ids = params[:tracks].to_s.split(",").map {|s| s.strip}
        if track_ids.empty?
          track_ids = Trackler.tracks.select(&:active?).map(&:id)
        end
        track_ids = track_ids & Trackler.tracks.map(&:id)

        implementations = []
        slugs_by_track_id = fetch_solutions(params[:key])

        track_ids.each do |track_id|
          track = Trackler.tracks[track_id]
          slugs = slugs_by_track_id[track_id]
          # pretend they already solved hello-world if they've
          # solved anything at all.
          slugs << 'hello-world' unless slugs.empty?
          next_slug = (track.problems.map(&:slug) - slugs).first
          if !!next_slug
            implementation = track.implementations[next_slug]
            if implementation.exists?
              implementations << implementation
            end
          end
        end

        pg :implementations, locals: { implementations: implementations }
      end

      get '/v2/exercises/:track_id' do |track_id|
        require_key

        track = find_track(track_id)

        implementations = []

        slugs_by_track_id = fetch_solutions(params[:key])
        slugs = slugs_by_track_id[track_id]

        # pretend they already solved hello-world if they've
        # solved anything at all.
        slugs << 'hello-world' unless slugs.empty?
        next_slug = (track.problems.map(&:slug) - slugs).first
        if !!next_slug
          implementation = track.implementations[next_slug]
          if implementation.exists?
            implementations << implementation
          end
        end

        pg :implementations, locals: { implementations: implementations }
      end

      get '/v2/exercises/:track_id/:slug' do |track_id, slug|
        track_id, slug = track_id.downcase, slug.downcase
        _, implementation = find_track_and_implementation(track_id, slug)
        pg :implementations, locals: { implementations: [implementation] }
      end

      private

      def fetch_solutions(key)
        solutions = forward_errors do
          Xapi::ExercismIO.exercises_for(key)
        end

        hash = Hash.new {|h,k| h[k] = []}
        solutions.each_with_object(hash) do |(track_id, problems), slugs_by_track_id|
          slugs_by_track_id[track_id] = problems.map {|problem|
            problem["slug"]
          }
        end
      end
    end
  end
end
