require 'ap'


# Go through file once and save down all symbols in a symbol table (hash)


file = ARGV.first
hack =  file[0..-5] + ".hack"
puts hack
File.open(file, "r").each do |line|


  # Strip out comments and blank lines
  if line[0..1] != "//" && !line.strip.empty?
    puts line
  end


end
