require 'json'

USAGE="
USAGE: #{File.basename($0)} /path/to/yaml.yml key_name_to_extract

"

if ARGV.length < 2
  puts USAGE
  abort "Not enough arguments."
end

file_name = ARGV[0]
key_name = ARGV[1]
puts JSON.parse(File.read(file_name))[key_name]
