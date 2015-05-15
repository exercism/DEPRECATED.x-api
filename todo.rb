require './lib/xapi'


# find the titles of all the problems and store it in an Array by using the file names of the yml files in the metadata folder, since each problem has 1 yml file.

filenames = Dir.glob("./metadata/*.yml")

slugs = []

# remove the './metadata' from the begining of the file name and the '.yml' from the end of the file name. Add all the names of the problems to the array slugs.

filenames.each do |filename|
  slugs << filename[11...-4]
end

#get an array of the tracks, aka the different programming languages

tracksfiles = Dir.glob("./problems/*")

#create the array tracks of all the programming languages, remove the './problems/' from each element of the trackfiles array

tracks = []

tracksfiles.each do |filename|
  tracks << filename[11..-1]
end

#Create the todo hash which will be a hash with key track and the value as an array of problems left to be created in that track.

todo = {}

tracks.each do |track|
  todo[track] = slugs - Xapi::Config.find(track).slugs
end

puts todo["ruby"]

