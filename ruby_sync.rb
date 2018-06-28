require "rsync"

input_array = ARGV

def sync_list(file_path)
  f = File.open(file_path, "r")
  f.each_line do |line|
    locations = line.split(" ")
    sync_target_sh(locations[0], locations[1])
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

def sync_target_sh(file, sync_location)
  cmd = "rsync -az " + file + " " + sync_location
  value = %x[ #{cmd} ]
  puts value
end

def append_target(file_path, file, location)
  f = File.open(file_path, 'a')
  f << file_path + " " + location
end

def main()
  file = "targets"
  sync_target_sh(file)
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
