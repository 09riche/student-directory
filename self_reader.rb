file = File.open($0)
file.readlines.each do |line|
  puts line
end
file.close
