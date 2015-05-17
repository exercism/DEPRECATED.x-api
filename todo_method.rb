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

  def print_todo(track)
    total_slugs = get_todo(track).size
    number_of_slugs_to_be_written = get_todo(track).size
    to_be_written = get_todo(track).size
    language = (track).capitalize
    puts "There are #{total_slugs} exercises that could be in this track. 
      Right now there are only #{number_of_slugs_to_be_written}.\n
      That means there are #{to_be_written} #{language} exercises that 
      need to be written to complete it's set.\n
      Contribute to this site and the open source community by 
        writing one of these exercises."
  end

  def track1_minus_track2(track1, track2)
    track1 = get_existing_slugs(track1)
    track2 = get_existing_slugs(track2)
    track1_minus_track2 = track1 - track2
    track1_minus_track2.sort
  end
end

tracker = Todo.new

puts ""
puts "------------------------------------------"
puts "------------------------------------------"
puts ""
puts "get_slugs - gets a list of all the unique exercises that currently exist in all the language tracks"
puts "---------------------"
puts ""
puts "get_slugs.size"
puts "---------------------"
puts tracker.get_slugs.size
puts ""
puts "get_slugs"
puts "---------------------"
puts tracker.get_slugs
puts ""
puts "------------------------------------------"
puts "------------------------------------------"
puts ""
puts "get_tracks - gets a list of all the language tracks"
puts "---------------------"
puts ""
puts "get_tracks.size"
puts "---------------------"
puts tracker.get_tracks.size
puts ""
puts "get_tracks"
puts "---------------------"
puts tracker.get_tracks
puts ""
puts "------------------------------------------"
puts "------------------------------------------"
puts ""
puts "get_existing_slugs - gets a list of all the exercises that currently exist in a particular language track"
puts "---------------------"
puts ""
puts "get_existing_slugs('python').size"
puts "---------------------"
puts tracker.get_existing_slugs('python').size
puts ""
puts "get_existing_slugs('python')"
puts "---------------------"
puts tracker.get_existing_slugs('python')
puts ""
puts "------------------------------------------"
puts "------------------------------------------"
puts ""
puts "get_todo - a list of the slugs that need to be made for a particular track"
puts "---------------------"
puts ""
puts "get_todo('ruby').size"
puts "---------------------"
puts tracker.get_todo('ruby').size
puts ""
puts "get_todo('ruby')"
puts "---------------------"
puts tracker.get_todo('ruby')
puts ""
puts "---------------------"
puts ""
puts "print_todo('ruby')"
puts "---------------------"
puts tracker.print_todo('ruby')
puts ""
puts "print_todo('python')"
puts "---------------------"
puts tracker.print_todo('python')
puts ""
puts "print_todo('r')"
puts "---------------------"
puts tracker.print_todo('r')
puts ""
puts "------------------------------------------"
puts "------------------------------------------"
puts ""
puts "track1_minus_track2(track1, track2) - gets a list of all the exercises that currently exist in a particular language track"
puts "---------------------"
puts ""
puts "track1_minus_track2('ruby', 'python').size"
puts "---------------------"
puts tracker.track1_minus_track2("ruby", "python").size
puts ""
puts "track1_minus_track2('ruby', 'python')"
puts "---------------------"
puts tracker.track1_minus_track2("ruby", "python")
puts ""
puts "------------------------------------------"
puts "------------------------------------------"

=begin 
# same as todo method
  def get_slugs_to_be_written(track)
    all_slugs = get_slugs.size
    existing_slugs = get_existing_slugs(track).size
    all_slugs - existing_slugs
  end
=end
