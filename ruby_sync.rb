require "rsync"
require "thor"
require "paint"
require "progress_bar"

input_array = ARGV

def sync_list(file_path)
  f = File.open(file_path, "r")

  # wc -l is an sh command for wordcount and -l as lines
  # This method is fast and memory efficient
  cmd = "wc -l " + file_path
  linecount = %x[ #{cmd} ].strip.split(' ')[0].to_i

  # Create a progress bar for listed files
  bar = ProgressBar.new(linecount, :bar, :counter, :elapsed, :rate)

  f.each_line do |line|
    locations = line.split(" ")
    sync_target_sh(locations[0], locations[1])
    bar.increment!
  end
  f.close
end

def print_file(file_path)
  File.open(file_path, "r") do |f|
    f.each_line do |line|
      puts line
    end
  end
end

def sync_target_sh(file, sync_location)
  cmd = "rsync -az " + file + " " + sync_location
  value = %x[ #{cmd} ]
end

def sync_target(file, sync_location)
  Rsync.run(file, sync_location) do |result|
    if result.success?
      result.changes.each do |change|
        puts "#{change.filename} (#{change.summary})"
      end
    else
      puts result.error
    end
  end
end

def append_target(file_path, file, location)
  f = File.open(file_path, 'a')
  f << file_path + " " + location
end

def main()
  file = "targets"
  sync_list(file)
end

main()

=begin
def test()
  loc = "/home/karl/Documents/Poems karl@192.168.1.10:/home/karl/Documents/"
  locations = loc.split(" ")
  sync_target_sh(locations[0], locations[1])
end

puts "Running test..."
test()
puts "Testing complete."
=end
