# slugs are the exercises that are written in each language
# track are the languages

require './lib/xapi'

class Todo

  def get_slugs
    slugs = []
    Dir.glob("./metadata/*.yml").each do |filename|
      slugs << filename[11...-4]
    end
    slugs.sort
  end

  def get_tracks
    tracks = []
    tracksfiles = Dir.glob("./problems/*")
    tracksfiles.each do |filename|
      tracks << filename[11..-1]
    end
    tracks.sort
  end

  def get_existing_slugs(track)
    existing_slugs = {}
    get_tracks.each do |track|
      existing_slugs[track] = Xapi::Config.find(track).slugs
    end
    existing_slugs[track].sort
  end

  def get_todo(track)
    todo = {}
    get_tracks.each do |track|
      todo[track] = get_slugs - get_existing_slugs(track)
    end
    todo[track]
  end
end
