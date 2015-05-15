require './lib/xapi'

class Todo

  
  def get_slugs
    slugs = []
    Dir.glob("./metadata/*.yml").each do |filename|
      slugs << filename[11...-4]
    end
    slugs
  end

  def get_tracks
    tracks = []
    tracksfiles = Dir.glob("./problems/*")
    tracksfiles.each do |filename|
      tracks << filename[11..-1]
    end
    tracks
  end

  def get_slugs_done
    slugs_done = {}
    get_tracks.each do |track|
        slugs_done[track] = Xapi::Config.find(track).slugs
    end
    slugs_done
  end

  def get_todo
    todo = {}
    get_tracks.each do |track|
      todo[track] = get_slugs - get_slugs_done[track]
    end
    todo
  end

  def track1_minus_track2(track1, track2)
    #what is done in track1 but not done in track2
    track1_minus_track2 = get_slugs_done[track1] - get_slugs_done[track2]
  end

  def exercises_to_be_written(track)
    all_slugs = get_slugs.size
    all_slugs - get_slugs_done[track].size
  end

  def print_exercises_to_be_written(track)
    to_be_written = exercises_to_be_written(track)
    language = (track).capitalize
    puts "There are #{to_be_written} #{language} exercises that need to be written to complete it's set."
  end
end

tracker = Todo.new
puts tracker.print_exercises_to_be_written("ruby")
puts tracker.print_exercises_to_be_written("python")
puts tracker.print_exercises_to_be_written("r")

go_track = tracker.exercises_to_be_written("go")
puts "There are #{go_track} go exercises that need to be written to complete it's set."
unique_slugs = tracker.get_slugs.length
puts "There are #{unique_slugs} unique exercises between all the languages. This is the list:"

python_track = tracker.exercises_to_be_written("python")
puts "There are #{python_track} go exercises that need to be written to complete it's set."

ruby_track = tracker.exercises_to_be_written("ruby")
puts "There are #{ruby_track} go exercises that need to be written to complete it's set."

#puts exercises_to_be_written
#puts get_todo("go")

=begin
puts""

       all_slugs = get_slugs.size
        go_track = get_slugs_done["go"].size
go_to_be_written = all_slugs - go_track

puts "There are #{all_slugs} unique exercises that appear in all the tracks.  
It would be great if each track had the same exercises. 
We could use your help with this."
puts""
puts "------------GO--------------"

puts "There are #{go_track} exercises already written in the Go Track."

puts "That means there are #{go_to_be_written} exercises that need to be written in the Go Track for it to have a complete set of exercises."

puts""
puts"-----------PYTHON--------------"

go_minus_python = track1_minus_track2("go", "python").size
python_track = get_slugs_done["python"].size
puts "There are #{python_track} exercises already written in the Python Track."
python_exercises_to_be_written =  all_slugs - python_track
puts "That means there are #{python_exercises_to_be_written} exercises that need to be written in the Go Track for it to have a complete set of exercises."


# puts track1_minus_track2("python", "go").size

# puts (track1_minus_track2("python", "go") == track1_minus_track2("go", "python"))

=end




