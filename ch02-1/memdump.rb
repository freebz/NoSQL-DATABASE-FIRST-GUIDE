require 'socket'

if ARGV.size != 2
  puts "Usage: ruby memdump.rb localhost 11211"
  exit
end

socket = TCPSocket.new(*ARGV)

puts "---"

items_h = {}

socket.puts "stats items"
while s = socket.gets
  break if s =~ /^END/
  if s =~ /^STAT items:(\d+):number (\d+)/
    items_h[$1] = $2;
  end
end

mem = 0
items_h.keys.each do |key|
  socket.puts "stats cachedump #{key} #{items_h[key]}"

  list = []
  while s = socket.gets
    break if s =~ /^END/
	list << $1 if s =~ /^ITEM (\w+) .+/
  end

  list.sort{|a,b| a.split(/_/)[-1].to_i <=> b.split(/_/)[-1].to_i}.each do |key|
    socket.puts "get #{key}"
    while s = socket.gets
      next if s =~ /^VALUE/
	  break if s =~ /^END/
#puts "#{key}: #{Marshal.load(s)}"
	  puts "#{key}: #{s}"
    end
  end

  socket.puts "stats slabs"
  while s = socket.gets
    break if s =~ /^END/
	mem += $1.to_i if s =~ /^STAT \d+:mem_requested (\d+)/
  end
end

puts "---"
puts "memory usage: #{mem}byte"

socket.close


